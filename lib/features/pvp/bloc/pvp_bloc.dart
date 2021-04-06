import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/features/pvp/models/data.dart';
import 'package:guildwars2_companion/features/pvp/models/game.dart';
import 'package:guildwars2_companion/features/pvp/models/standing.dart';
import 'package:guildwars2_companion/features/pvp/models/stats.dart';
import 'package:guildwars2_companion/features/pvp/repositories/pvp.dart';
import 'package:meta/meta.dart';

part 'pvp_event.dart';
part 'pvp_state.dart';

class PvpBloc extends Bloc<PvpEvent, PvpState> {
  final PvpRepository pvpRepository;

  PvpBloc({
    @required this.pvpRepository,
  }): super(LoadingPvpState());

  @override
  Stream<PvpState> mapEventToState(
    PvpEvent event,
  ) async* {
    if (event is LoadPvpEvent) {
      try {
        yield LoadingPvpState();

        PvpData pvpData = await pvpRepository.getPvpData();

        yield LoadedPvpState(
          pvpGames: pvpData.pvpGames,
          pvpStandings: pvpData.pvpStandings,
          pvpStats: pvpData.pvpStats,
        );
      } catch (_) {
        yield ErrorPvpState();
      }
    } else if (event is ResetPvpEvent) {
      yield LoadingPvpState();
    }
  }
}
