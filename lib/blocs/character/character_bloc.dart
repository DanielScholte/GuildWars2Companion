import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/repositories/build.dart';
import 'package:guildwars2_companion/repositories/character.dart';
import './bloc.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final BuildRepository buildRepository;
  final CharacterRepository characterRepository;

  List<Character> _characters;

  CharacterBloc({
    @required this.buildRepository,
    @required this.characterRepository,
  }): super(LoadingCharactersState());

  @override
  Stream<CharacterState> mapEventToState(
    CharacterEvent event,
  ) async* {
    if (event is LoadCharactersEvent) {
      yield* _loadCharacters();
    } else if (event is LoadCharacterDetailsEvent) {
      yield* _loadCharacterDetails();
    } else if (event is RefreshCharacterDetailsEvent) {
      yield* _refreshCharacterDetails();
    }
  }
  
  Stream<CharacterState> _loadCharacters() async* {
    try {
      yield LoadingCharactersState();

      _characters = await characterRepository.getCharacters();

      yield LoadedCharactersState(_characters);
    } catch (_) {
      yield ErrorCharactersState();
    }
  }

  Stream<CharacterState> _loadCharacterDetails() async* {
    try {
      yield LoadedCharactersState(_characters, detailsLoading: true);

      await characterRepository.getCharacterItems(_characters);
      await buildRepository.fillBuildInformation(_characters.map((c) => c.buildTabs.map((e) => e.build)).expand((b) => b).toList());

      yield LoadedCharactersState(_characters, detailsLoaded: true);
    } catch(_) {
      yield LoadedCharactersState(_characters, detailsError: true);
    }
  }

  Stream<CharacterState> _refreshCharacterDetails() async* {
    try {
      yield LoadingCharactersState();

      _characters = await characterRepository.getCharacters();

      await characterRepository.getCharacterItems(_characters);
      await buildRepository.fillBuildInformation(_characters.map((c) => c.buildTabs.map((e) => e.build)).expand((b) => b).toList());

      yield LoadedCharactersState(_characters, detailsLoaded: true);
    } catch (_) {
      yield ErrorCharactersState();
    }
  }
}
