import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/title.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  @override
  CharacterState get initialState => LoadingCharactersState();

  @override
  Stream<CharacterState> mapEventToState(
    CharacterEvent event,
  ) async* {
    if (event is LoadCharactersEvent) {
      yield LoadingCharactersState();

      List<Character> characters = await _getCharacters();
      List<Title> titles = await _getTitles();

      yield LoadedCharactersState(characters, false);
    }
  }

  Future<List<Character>> _getCharacters() async {
    final response = await http.get(
      Urls.charactersUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List characters = json.decode(response.body);
      return characters.map((a) => Character.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<Title>> _getTitles() async {
    final response = await http.get(
      Urls.titlesUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List titles = json.decode(response.body);
      return titles.map((a) => Title.fromJson(a)).toList();
    } else {
      return [];
    }
  }
}
