import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';
import 'package:guildwars2_companion/features/meta_event/repositories/event.dart';
import 'package:guildwars2_companion/features/world_boss/repositories/world_boss.dart';

part 'world_boss_event.dart';
part 'world_boss_state.dart';

class WorldBossBloc extends Bloc<WorldBossEvent, WorldBossState> {
  final MetaEventRepository eventRepository;
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
