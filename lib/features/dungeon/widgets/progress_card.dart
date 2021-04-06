import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/dungeon/models/dungeon.dart';

class DungeonProgressCard extends StatelessWidget {
  final Dungeon dungeon;
  final bool includeProgress;

  DungeonProgressCard({
    @required this.dungeon,
    @required this.includeProgress
  });

  @override
  Widget build(BuildContext context) {
    return CompanionInfoCard(
      title: includeProgress ? 'Daily Progress' : 'Paths',
      child: Column(
      children: dungeon.paths
        .map((p) => Row(
          children: <Widget>[
            if (p.completed)
              Icon(
                FontAwesomeIcons.check,
                size: 20.0,
              )
            else
              Container(
                width: 20.0,
                child: Icon(
                  FontAwesomeIcons.solidCircle,
                  size: 6.0,
                ),
              ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  p.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ))
        .toList(),
      ),
    );
  }
}