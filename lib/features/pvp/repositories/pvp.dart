import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/pvp/models/map.dart';
import 'package:guildwars2_companion/features/pvp/models/data.dart';
import 'package:guildwars2_companion/features/pvp/models/game.dart';
import 'package:guildwars2_companion/features/pvp/models/rank.dart';
import 'package:guildwars2_companion/features/pvp/models/season.dart';
import 'package:guildwars2_companion/features/pvp/models/standing.dart';
import 'package:guildwars2_companion/features/pvp/models/stats.dart';
import 'package:guildwars2_companion/features/pvp/services/map.dart';
import 'package:guildwars2_companion/features/pvp/services/pvp.dart';

class PvpRepository {

  final MapService mapService;
  final PvpService pvpService;

  PvpRepository({
    @required this.mapService,
    @required this.pvpService
  });

  Future<PvpData> getPvpData() async {
    List networkResults = await Future.wait([
      pvpService.getStats(),
      pvpService.getRanks(),
      pvpService.getStandings(),
      pvpService.getGames()
    ]);

    PvpStats stats = networkResults[0];
    List<PvpRank> ranks = networkResults[1];
    List<PvpStanding> standings = networkResults[2];
    List<PvpGame> games = networkResults[3];

    List<int> mapIds = [];
    List<String> seasonIds = [];

    games.forEach((g) => mapIds.add(g.mapId));
    standings.forEach((s) => seasonIds.add(s.seasonId));

    List<GameMap> maps = mapIds.isEmpty ? [] : await mapService.getMaps(mapIds.toSet().toList());
    List<PvpSeason> seasons = seasonIds.isEmpty ? [] : await pvpService.getSeasons(seasonIds.toSet().toList());

    stats.rank = ranks.firstWhere((r) => r.levels.any((l) => l.minRank <= stats.pvpRank && l.maxRank >= stats.pvpRank), orElse: () => ranks.first);
    ranks.forEach((rank) {
      rank.levels.forEach((level) {
        for (int i = level.minRank; i <= level.maxRank; i++) {
          if (stats.pvpRankPoints - level.points >= 0){
            stats.pvpRankPoints -= level.points;
          } else if (stats.pvpRankPointsNeeded == null) {
            stats.pvpRankPointsNeeded = level.points;
          }
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
    games.sort((a, b) => -a.started.compareTo(b.started));

    return PvpData(
      pvpStats:  stats,
      pvpGames: games,
      pvpStandings: standings
    );
  }
}