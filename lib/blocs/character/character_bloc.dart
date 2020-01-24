import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/repositories/character.dart';
import './bloc.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  @override
  CharacterState get initialState => LoadingCharactersState();

  final CharacterRepository characterRepository;

  CharacterBloc({
    @required this.characterRepository,
  });

  @override
  Stream<CharacterState> mapEventToState(
    CharacterEvent event,
  ) async* {
    if (event is LoadCharactersEvent) {
      yield* _loadCharacters();
    } else if (event is LoadCharacterItemsEvent) {
      yield* _loadCharacterItems(event.characters);
    } else if (event is RefreshCharacterItemsEvent) {
      yield* _refreshCharacterItems();
    }
  }
  
  Stream<CharacterState> _loadCharacters() async* {
    try {
      yield LoadingCharactersState();

      yield LoadedCharactersState(await characterRepository.getCharacters());
    } catch (_) {
      yield ErrorCharactersState();
    }
  }

  Stream<CharacterState> _loadCharacterItems(List<Character> characters) async* {
    try {
      yield LoadedCharactersState(characters, itemsLoading: true);

      yield LoadedCharactersState(await characterRepository.getCharacterItems(characters), itemsLoaded: true);
    } catch(_) {
      yield LoadedCharactersState(characters, hasError: true);
    }
  }

  Stream<CharacterState> _refreshCharacterItems() async* {
    try {
      yield LoadingCharactersState();

      List<Character> characters = await characterRepository.getCharacters();

      yield LoadedCharactersState(await characterRepository.getCharacterItems(characters), itemsLoaded: true);
    } catch (_) {
      yield ErrorCharactersState();
    }
  }
}
