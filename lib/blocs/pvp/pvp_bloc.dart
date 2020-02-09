import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/pvp/data.dart';
import 'package:guildwars2_companion/models/pvp/game.dart';
import 'package:guildwars2_companion/models/pvp/standing.dart';
import 'package:guildwars2_companion/models/pvp/stats.dart';
import 'package:guildwars2_companion/repositories/pvp.dart';
import 'package:meta/meta.dart';

part 'pvp_event.dart';
part 'pvp_state.dart';

class PvpBloc extends Bloc<PvpEvent, PvpState> {
  @override
  PvpState get initialState => LoadingPvpState();

  final PvpRepository pvpRepository;

  PvpBloc({
    @required this.pvpRepository,
  });

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
    }
  }
}
