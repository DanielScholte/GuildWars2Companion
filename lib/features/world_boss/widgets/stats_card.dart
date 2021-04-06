import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/core/widgets/info_row.dart';
import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';

class WorldBossStatsCard extends StatelessWidget {
  final WorldBoss worldBoss;

  const WorldBossStatsCard({
    Key key,
    @required this.worldBoss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CompanionInfoCard(
      title: 'Stats',
      child: Column(
        children: [
          CompanionInfoRow(
            header: 'Level',
            text: worldBoss.level.toString()
          ),
          CompanionInfoRow(
            header: 'Map',
            text: worldBoss.location
          ),
          CompanionInfoRow(
            header: 'Waypoint',
            text: worldBoss.waypoint
          ),
        ],
      ),
    );
  }
}