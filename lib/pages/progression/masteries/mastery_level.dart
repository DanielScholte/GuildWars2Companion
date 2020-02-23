import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';

class MasteryLevelPage extends StatelessWidget {

  final Mastery mastery;
  final MasteryLevel level;

  MasteryLevelPage(this.mastery, this.level);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: GuildWarsUtil.regionColor(mastery.region),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CompanionHeader(
              includeBack: true,
              color: GuildWarsUtil.regionColor(mastery.region),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: level.name,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: CompanionCachedImage(
                          height: 60.0,
                          imageUrl: level.icon,
                          color: Colors.white,
                          iconSize: 28,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  if (level.done)
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Completed',
                        style: Theme.of(context).textTheme.display3
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      level.name,
                      style: Theme.of(context).textTheme.display1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      mastery.name,
                      style: Theme.of(context).textTheme.display3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  if (level.description != null && level.description.isNotEmpty)
                    _buildDescription(context, 'Description', level.description),
                  if (level.instruction != null && level.instruction.isNotEmpty)
                    _buildDescription(context, 'Instructions', level.instruction),
                  CompanionCard(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Information',
                            style: Theme.of(context).textTheme.display2.copyWith(
                              color: Colors.black
                            ),
                          ),
                        ),
                        CompanionInfoRow(
                          header: 'Region',
                          text: mastery.region
                        ),
                        CompanionInfoRow(
                          header: 'Mastery points',
                          text: level.pointCost.toString()
                        ),
                        CompanionInfoRow(
                          header: 'Experience',
                          text: GuildWarsUtil.intToString(level.expCost)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildDescription(BuildContext context, String title, String text) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.display2.copyWith(
                color: Colors.black
              ),
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.display3.copyWith(
              color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
}