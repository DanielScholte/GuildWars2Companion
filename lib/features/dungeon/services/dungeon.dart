import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/dungeon/models/dungeon.dart';

class DungeonService {
  List<Dungeon> _dungeons;
  Dio dio;

  DungeonService({
    @required this.dio,
  });

  Future<List<String>> getCompletedDungeons() async {
    final response = await dio.get(Urls.completedDungeonsUrl);

    if (response.statusCode == 200) {
      List dungeons = response.data;
      return dungeons.map((a) => a.toString()).toList();
    }

    throw Exception();
  }

  Future<List<Dungeon>> getDungeons() async {
    if (_dungeons == null) {
      List dungeonData = await Assets.loadDataAsset(Assets.dungeons);
      _dungeons = dungeonData
        .map((d) => Dungeon.fromJson(d))
        .toList();
    }
    
    return _dungeons;
  }
}
