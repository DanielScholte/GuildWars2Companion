import 'package:guildwars2_companion/features/pvp/models/game.dart';
import 'package:guildwars2_companion/features/pvp/models/standing.dart';
import 'package:guildwars2_companion/features/pvp/models/stats.dart';

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