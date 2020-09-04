import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/repositories/event.dart';
import 'package:guildwars2_companion/repositories/world_boss.dart';
import './bloc.dart';
class WorldBossBloc extends Bloc<WorldBossEvent, WorldBossState> {
  final EventRepository eventRepository;
  final WorldBossRepository worldBossRepository;

  bool includeProgress = false;

  WorldBossBloc({
    @required this.eventRepository,
    @required this.worldBossRepository
  }): super(LoadingWorldbossesState());

  @override
  Stream<WorldBossState> mapEventToState(
    WorldBossEvent event,
  ) async* {
    if (event is LoadWorldbossesEvent)  {
      try {
        if (event.showLoading) {
          yield LoadingWorldbossesState();
        }

        if (event.includeProgress != null) {
          includeProgress = event.includeProgress;
        }

        List<WorldBoss> worldBosses = await worldBossRepository.getWorldBosses(includeProgress);
        List<MetaEventSequence> sequences = worldBossRepository.getWorldBossSequences();
        
        sequences.forEach((s) => eventRepository.processMetaEventSequence(s));

        worldBosses.forEach((w) {
          w.segment = [
            ...sequences.first.segments,
            ...sequences.last.segments 
          ].firstWhere((s) => s.id == w.id);
          w.segment.name = w.name;
        });

        worldBosses.sort((a, b) => a.segment.time.compareTo(b.segment.time));

        yield LoadedWorldbossesState(worldBosses);
      } catch (_) {
        yield ErrorWorldbossesState();
      }
    }
  }
}
