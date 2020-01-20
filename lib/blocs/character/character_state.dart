import 'package:guildwars2_companion/models/character/character.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CharacterState {}
  
class LoadingCharactersState extends CharacterState {}

class LoadedCharactersState extends CharacterState {
  final List<Character> characters;

  final bool itemsLoaded;
  final bool itemsLoading;
  final bool hasError;

  LoadedCharactersState(this.characters, {
    this.itemsLoaded = false,
    this.itemsLoading = false,
    this.hasError = false,
  });
}

class ErrorCharactersState extends CharacterState {}