import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/other/map.dart';
import 'package:guildwars2_companion/models/pvp/data.dart';
import 'package:guildwars2_companion/models/pvp/game.dart';
import 'package:guildwars2_companion/models/pvp/rank.dart';
import 'package:guildwars2_companion/models/pvp/season.dart';
import 'package:guildwars2_companion/models/pvp/standing.dart';
import 'package:guildwars2_companion/models/pvp/stats.dart';
import 'package:guildwars2_companion/services/map.dart';
import 'package:guildwars2_companion/services/pvp.dart';

class PvpRepository {

  final MapService mapService;
  final PvpService pvpService;

  PvpRepository({
    @required this.mapService,
    @required this.pvpService
  });

  Future<PvpData> getPvpData() async {
    PvpStats stats = await pvpService.getStats();
    List<PvpRank> ranks = await pvpService.getRanks();
    List<PvpStanding> standings = await pvpService.getStandings();
    List<PvpGame> games = await pvpService.getGames();

    List<int> mapIds = [];
    List<String> seasonIds = [];

    games.forEach((g) => mapIds.add(g.mapId));
    standings.forEach((s) => seasonIds.add(s.seasonId));

    List<GameMap> maps = mapIds.isEmpty ? [] : await mapService.getMaps(mapIds.toSet().toList());
    List<PvpSeason> seasons = seasonIds.isEmpty ? [] : await pvpService.getSeasons(seasonIds.toSet().toList());

    stats.rank = ranks.firstWhere((r) => r.levels.any((l) => l.minRank <= stats.pvpRank && l.maxRank >= stats.pvpRank), orElse: () => ranks.first);
    ranks.forEach((rank) {
      rank.levels.forEach((level) {
        if (stats.pvpRankPoints - level.points >= 0){
          stats.pvpRankPoints -= level.points;
        }
      });
    });

    standings.forEach((standing) {
      standing.season = seasons.firstWhere((s) => s.id == standing.seasonId, orElse: () => null);
    });
    standings.removeWhere((s) => s.season == null || s.season.ranks == null);
    standings.sort((a, b) => -a.season.start.compareTo(b.season.start));

    games.forEach((game) {
      game.map = maps.firstWhere((m) => m.id == game.mapId, orElse: () => null);
    });

    return PvpData(
      pvpStats:  stats,
      pvpGames: games,
      pvpStandings: standings
    );
  }
}