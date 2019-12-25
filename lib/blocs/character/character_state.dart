import 'package:guildwars2_companion/models/character/character.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CharacterState {}
  
class LoadingCharactersState extends CharacterState {}

class LoadedCharactersState extends CharacterState {
  final List<Character> characters;
  final bool itemsLoaded;

  LoadedCharactersState(this.characters, this.itemsLoaded);
}