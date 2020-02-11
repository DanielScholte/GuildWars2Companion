import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
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
    return Theme(
      data: Theme.of(context).copyWith(accentColor: GuildWarsUtil.regionColor(mastery.region)),
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
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      level.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      mastery.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
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
                    _buildDescription('Description', level.description),
                  if (level.instruction != null && level.instruction.isNotEmpty)
                    _buildDescription('Instructions', level.instruction),
                  CompanionCard(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Information',
                            style: TextStyle(
                              fontSize: 18.0
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

  Widget _buildDescription(String title, String text) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
        ],
      ),
    );
  }
}