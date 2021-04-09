import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/pvp/models/map.dart';

class MapService {
  Dio dio;

  MapService({
    @required this.dio,
  });

  Future<List<GameMap>> getMaps(List<int> mapIds) async {
    List<String> mapIdsList = Urls.divideIdLists(mapIds);
    List<GameMap> maps = [];
    for (var mapIds in mapIdsList) {
      final response = await dio.get(Urls.mapsUrl + mapIds);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List responseMaps = response.data;
        maps.addAll(responseMaps.map((a) => GameMap.fromJson(a)).toList());
        continue;
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    return maps;
  }
}