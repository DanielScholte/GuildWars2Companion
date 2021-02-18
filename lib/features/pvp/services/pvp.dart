import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/pvp/models/game.dart';
import 'package:guildwars2_companion/features/pvp/models/rank.dart';
import 'package:guildwars2_companion/features/pvp/models/season.dart';
import 'package:guildwars2_companion/features/pvp/models/standing.dart';
import 'package:guildwars2_companion/features/pvp/models/stats.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class PvpService {

  Dio dio;

  PvpService({
    @required this.dio,
  });

  Future<PvpStats> getStats() async {
    final response = await dio.get(Urls.pvpStatsUrl);

    if (response.statusCode == 200) {
      return PvpStats.fromJson(response.data);
    }

    throw Exception();
  }

  Future<List<PvpRank>> getRanks() async {
    final response = await dio.get(Urls.pvpRanksUrl);

    if (response.statusCode == 200) {
      List ranks = response.data;
      return ranks.map((a) => PvpRank.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<PvpStanding>> getStandings() async {
    final response = await dio.get(Urls.pvpStandingsUrl);

    if (response.statusCode == 200) {
      List standings = response.data;
      return standings.map((a) => PvpStanding.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<PvpGame>> getGames() async {
    final response = await dio.get(Urls.pvpGamesUrl);

    if (response.statusCode == 200) {
      List games = response.data;
      return games.map((a) => PvpGame.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<PvpSeason>> getSeasons(List<String> seasonIds) async {
    final response = await dio.get(Urls.pvpSeasonsUrl + Urls.combineStringIds(seasonIds));

    if (response.statusCode == 200) {
      List seasons = response.data;
      return seasons.map((a) => PvpSeason.fromJson(a)).toList();
    }

    throw Exception();
  }
}