part of 'pvp_bloc.dart';

@immutable
abstract class PvpEvent {}

class LoadPvpEvent extends PvpEvent {}

class ResetPvpEvent extends PvpEvent {}
