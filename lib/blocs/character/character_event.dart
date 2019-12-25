import 'package:meta/meta.dart';

@immutable
abstract class CharacterEvent {}

class LoadCharactersEvent extends CharacterEvent {}