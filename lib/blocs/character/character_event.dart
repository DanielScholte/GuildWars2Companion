import 'package:meta/meta.dart';

@immutable
abstract class CharacterEvent {}

class LoadCharactersEvent extends CharacterEvent {}

class LoadCharacterDetailsEvent extends CharacterEvent {}

class RefreshCharacterDetailsEvent extends CharacterEvent {}