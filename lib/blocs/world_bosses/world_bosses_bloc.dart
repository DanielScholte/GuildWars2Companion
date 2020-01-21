import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/repositories/world_bosses.dart';
import './bloc.dart';
class WorldBossesBloc extends Bloc<WorldBossesEvent, WorldBossesState> {
  @override
  WorldBossesState get initialState => LoadingWorldbossesState();

  final WorldBossesRepository worldBossesRepository;

  WorldBossesBloc({
    @required this.worldBossesRepository
  });

  @override
  Stream<WorldBossesState> mapEventToState(
    WorldBossesEvent event,
  ) async* {
    if (event is LoadWorldbossesEvent)  {
      try {
        if (event.showLoading) {
          yield LoadingWorldbossesState();
        }

        List<WorldBoss> worldBosses = worldBossesRepository.getWorldBosses();

        DateTime now = DateTime.now().toUtc();

        List<String> completedWorldBosses;
        if (event.includeProgress) {
          completedWorldBosses = await worldBossesRepository.getCompletedWorldBosses();
        }

        worldBosses.forEach((worldBoss) {
          List<DateTime> times = worldBoss.times
            .map((t) {
              List<int> timeParts = t.split(':').map((p) => int.parse(p)).toList();
              return DateTime.utc(
                now.year,
                now.month,
                now.day,
                timeParts[0],
                timeParts[1]
              );
            })
            .toList();
          DateTime next = times
            .firstWhere((t) => t.add(Duration(minutes: 15)).isAfter(now), orElse: () => times[0].add(Duration(days: 1)));
          worldBoss.dateTime = next;
          worldBoss.refreshTime = next.add(Duration(minutes: 15));
          if (event.includeProgress) {
            worldBoss.completed = completedWorldBosses.contains(worldBoss.id);
          }
        });
        worldBosses.sort((a, b) => a.dateTime.compareTo(b.dateTime));

        yield LoadedWorldbossesState(worldBosses, event.includeProgress);
      } catch (_) {
        yield ErrorWorldbossesState(event.includeProgress);
      }
    }
  }
}
