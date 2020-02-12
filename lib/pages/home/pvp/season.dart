import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/pvp/season.dart';
import 'package:guildwars2_companion/models/pvp/standing.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/pvp_season_rank.dart';
import 'package:intl/intl.dart';

class SeasonPage extends StatelessWidget {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final PvpSeasonRank rank;
  final PvpStanding standing;

  SeasonPage({
    @required this.rank,
    @required this.standing
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.blueGrey),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CompanionHeader(
              color: Colors.blueGrey,
              includeBack: true,
              child: Column(
                children: <Widget>[
                  CompanionPvpSeasonRank(
                    rank: rank,
                    standing: standing,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      standing.season.name,
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Text(
                    _dateFormat.format(DateTime.parse(standing.season.start)) +
                          (standing.season.end != null ? ' - ' + _dateFormat.format(DateTime.parse(standing.season.end)) : ''),
                    style: Theme.of(context).textTheme.display3,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  _buildRewards(context)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRewards(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Rewards',
              style: Theme.of(context).textTheme.display2.copyWith(
                color: Colors.black
              )
            ),
          ),
        ],
      ),
    );
  }
}