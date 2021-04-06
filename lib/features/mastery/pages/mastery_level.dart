import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/core/widgets/info_row.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/mastery/models/mastery.dart';

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
                        if (Theme.of(context).brightness == Brightness.light)
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
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.white
                        )
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      level.name,
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      mastery.name,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CompanionListView(
                children: <Widget>[
                  if (level.description != null && level.description.isNotEmpty)
                    CompanionInfoCard(title: 'Description', text: level.description),
                  if (level.instruction != null && level.instruction.isNotEmpty)
                    CompanionInfoCard(title: 'Instructions', text: level.instruction),
                  CompanionInfoCard(
                    title: 'Instructions',
                    child: Column(
                      children: [
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}