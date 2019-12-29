import 'package:guildwars2_companion/models/character/character.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CharacterEvent {}

class LoadCharactersEvent extends CharacterEvent {}

class LoadCharacterItemsEvent extends CharacterEvent {
  final List<Character> characters;

  LoadCharacterItemsEvent(this.characters);
}