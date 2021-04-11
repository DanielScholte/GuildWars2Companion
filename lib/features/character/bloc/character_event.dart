part of 'character_bloc.dart';

@immutable
abstract class CharacterEvent {}

class LoadCharactersEvent extends CharacterEvent {}

class LoadCharacterDetailsEvent extends CharacterEvent {}

class RefreshCharacterDetailsEvent extends CharacterEvent {}