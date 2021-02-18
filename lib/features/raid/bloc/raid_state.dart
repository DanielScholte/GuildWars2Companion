part of 'raid_bloc.dart';

@immutable
abstract class RaidState {}

class LoadingRaidsState extends RaidState {}

class LoadedRaidsState extends RaidState {
  final List<Raid> raids;
  final bool includeProgress;

  LoadedRaidsState(this.raids, this.includeProgress);
}

class ErrorRaidsState extends RaidState {
  final bool includeProgress;

  ErrorRaidsState(this.includeProgress);
}