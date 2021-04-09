import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/raid/models/raid.dart';

class RaidService {
  List<Raid> _raids;
  Dio dio;

  RaidService({
    @required this.dio,
  });

  Future<List<String>> getCompletedRaids() async {
    final response = await dio.get(Urls.completedRaidsUrl);

    if (response.statusCode == 200) {
      List dungeons = response.data;
      return dungeons.map((a) => a.toString()).toList();
    }

    throw Exception();
  }

  Future<List<Raid>> getRaids() async {
    if (_raids == null) {
      List dungeonData = await Assets.loadDataAsset(Assets.raids);
      _raids = dungeonData
        .map((d) => Raid.fromJson(d))
        .toList();
    }
    
    return _raids;
  }
}