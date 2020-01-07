import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/other/dungeon.dart';
import 'package:guildwars2_companion/repositories/dungeon.dart';
import './bloc.dart';

class DungeonBloc extends Bloc<DungeonEvent, DungeonState> {
  @override
  DungeonState get initialState => LoadingDungeonsState();

  final DungeonRepository dungeonsRepository;

  DungeonBloc({
    this.dungeonsRepository
  });

  @override
  Stream<DungeonState> mapEventToState(
    DungeonEvent event,
  ) async* {
    if (event is LoadDungeonsEvent) {
      List<Dungeon> dungeons = dungeonsRepository.getDungeons();

      List<String> completedDungeons = await dungeonsRepository.getCompletedDungeons();
      dungeons.forEach((d) => d.completed = completedDungeons.contains(d.pathId));

      yield LoadedDungeonsState(dungeons);
    }
  }
}
