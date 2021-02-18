import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/raid/models/raid.dart';
import 'package:guildwars2_companion/features/raid/services/raid.dart';

class RaidRepository {
  final RaidService raidService;

  RaidRepository({
    @required this.raidService,
  });

  Future<List<Raid>> getRaids(bool includeProgress) async {
    List<Raid> raids = raidService.getRaids();

    if (includeProgress) {
      List<String> completedCheckpoints = await raidService.getCompletedRaids();
      raids.forEach((d) {
        d.checkpoints.forEach((c) => c.completed = completedCheckpoints.contains(c.id));
      });
    }

    return raids;
  }
}