import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/other/raid.dart';
import 'package:guildwars2_companion/repositories/raid.dart';
import 'package:meta/meta.dart';

part 'raid_event.dart';
part 'raid_state.dart';

class RaidBloc extends Bloc<RaidEvent, RaidState> {
  @override
  RaidState get initialState => LoadingRaidsState();

  final RaidRepository raidRepository;

  RaidBloc({
    this.raidRepository,
  });

  @override
  Stream<RaidState> mapEventToState(
    RaidEvent event,
  ) async* {
    if (event is LoadRaidsEvent) {
      try {
        yield LoadingRaidsState();

        yield LoadedRaidsState(await raidRepository.getRaids(event.includeProgress), event.includeProgress);
      } catch(_) {
        yield ErrorRaidsState(event.includeProgress);
      }
    }
  }
}
