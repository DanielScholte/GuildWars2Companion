part of 'character_bloc.dart';

@immutable
abstract class CharacterState {}
  
class LoadingCharactersState extends CharacterState {}

class LoadedCharactersState extends CharacterState {
  final List<Character> characters;

  final bool detailsLoaded;
  final bool detailsLoading;
  final bool detailsError;

  LoadedCharactersState(this.characters, {
    this.detailsLoaded = false,
    this.detailsLoading = false,
    this.detailsError = false,
  });
}

class ErrorCharactersState extends CharacterState {}