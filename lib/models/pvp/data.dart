import 'package:guildwars2_companion/models/pvp/game.dart';
import 'package:guildwars2_companion/models/pvp/standing.dart';
import 'package:guildwars2_companion/models/pvp/stats.dart';

class PvpData {
  final PvpStats pvpStats;
  final List<PvpStanding> pvpStandings;
  final List<PvpGame> pvpGames;

  PvpData({
    this.pvpStats,
    this.pvpStandings,
    this.pvpGames,
  });
}