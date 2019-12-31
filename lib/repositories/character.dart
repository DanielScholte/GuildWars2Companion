import 'dart:convert';

import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/profession.dart';
import 'package:guildwars2_companion/models/character/title.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:http/http.dart' as http;

class CharacterRepository {
  Future<List<Character>> getCharacters() async {
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

  Future<List<AccountTitle>> getTitles() async {
    final response = await http.get(
      Urls.titlesUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List titles = json.decode(response.body);
      return titles.map((a) => AccountTitle.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<Profession>> getProfessions() async {
    final response = await http.get(
      Urls.professionsUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List professions = json.decode(response.body);
      return professions.map((a) => Profession.fromJson(a)).toList();
    } else {
      return [];
    }
  }
}