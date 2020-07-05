import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/repositories/world_boss.dart';
import './bloc.dart';
class WorldBossBloc extends Bloc<WorldBossEvent, WorldBossState> {
  final WorldBossRepository worldBossRepository;

  WorldBossBloc({
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

        yield LoadedWorldbossesState(await worldBossRepository.getWorldBosses(event.includeProgress), event.includeProgress);
      } catch (_) {
        yield ErrorWorldbossesState(event.includeProgress);
      }
    }
  }
}
