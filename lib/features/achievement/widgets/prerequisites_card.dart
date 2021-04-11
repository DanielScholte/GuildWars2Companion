import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement.dart';
import 'package:guildwars2_companion/features/achievement/widgets/achievement_button.dart';

class AchievementPrerequisitesCard extends StatelessWidget {
  final Achievement achievement;
  final bool includeProgression;

  AchievementPrerequisitesCard({
    @required this.achievement,
    @required this.includeProgression
  });

  @override
  Widget build(BuildContext context) {
    return CompanionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              'Prerequisites',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Column(
            children: achievement.prerequisitesInfo
              .map((p) => AchievementButton(
                includeProgression: includeProgression,
                achievement: p,
                hero: 'pre ${p.id} ${achievement.prerequisitesInfo.indexOf(p)}',
              ))
              .toList(),
          ),
          Container(height: 4.0,)
        ],
      ),
    );
  }
}