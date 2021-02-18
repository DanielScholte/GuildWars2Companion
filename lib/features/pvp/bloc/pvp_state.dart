part of 'pvp_bloc.dart';

@immutable
abstract class PvpState {}

class LoadingPvpState extends PvpState {}

class LoadedPvpState extends PvpState {
  final PvpStats pvpStats;
  final List<PvpStanding> pvpStandings;
  final List<PvpGame> pvpGames;

  LoadedPvpState({
    this.pvpStats,
    this.pvpStandings,
    this.pvpGames
  });
}

class ErrorPvpState extends PvpState {}