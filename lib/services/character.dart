import 'package:dio/dio.dart';
import '../models/character/character.dart';
import '../models/character/profession.dart';
import '../models/character/title.dart';
import '../utils/dio.dart';
import '../utils/urls.dart';

class CharacterService {
  List<AccountTitle> _titles;

  Dio _dio;

  CharacterService() {
    _dio = DioUtil.getDioInstance();
  }

  Future<List<Character>> getCharacters() async {
    final response = await _dio.get(Urls.charactersUrl);

    if (response.statusCode == 200) {
      List characters = response.data;
      return characters.map((a) => Character.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<AccountTitle>> getTitles() async {
    if (_titles != null && _titles.isNotEmpty) {
      return _titles;
    }

    final response = await _dio.get(Urls.titlesUrl);

    if (response.statusCode == 200) {
      List titles = response.data;
      _titles = titles.map((a) => AccountTitle.fromJson(a)).toList();
      return _titles;
    }

    throw Exception();
  }

  Future<List<Profession>> getProfessions() async {
    final response = await _dio.get(Urls.professionsUrl);

    if (response.statusCode == 200) {
      List professions = response.data;
      return professions.map((a) => Profession.fromJson(a)).toList();
    }

    throw Exception();
  }
}
