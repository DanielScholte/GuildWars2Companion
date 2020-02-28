import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/providers/configuration.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorldBossPage extends StatelessWidget {

  final WorldBoss worldBoss;

  WorldBossPage(this.worldBoss);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: worldBoss.color,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  _buildStats(context),
                  _buildTimes(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CompanionHeader(
      color: worldBoss.color,
      wikiName: worldBoss.name,
      wikiRequiresEnglish: true,
      includeBack: true,
      child: Column(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
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
              tag: worldBoss.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset('assets/world_bosses/${worldBoss.id}.jpg'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              worldBoss.name,
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            worldBoss.location,
            style: Theme.of(context).textTheme.display3.copyWith(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Stats',
              style: Theme.of(context).textTheme.display2,
            ),
          ),
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

  Widget _buildTimes(BuildContext context) {
    return Consumer<ConfigurationProvider>(
      builder: (context, state, child) {
        final DateFormat timeFormat = state.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

        return CompanionCard(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Spawn Times',
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 16.0,
                runSpacing: 4.0,
                children: _getSpawnTimes(worldBoss.times)
                  .map((t) => Chip(
                    backgroundColor: Theme.of(context).brightness == Brightness.light ? worldBoss.color : Colors.white12,
                    label: Text(
                      timeFormat.format(t),
                      style: Theme.of(context).textTheme.display3.copyWith(
                        color: Colors.white
                      ),
                    ),
                  ))
                  .toList()
              )
            ],
          ),
        );
      }
    );
  }

  List<DateTime> _getSpawnTimes(List<String> times) {
    DateTime now = DateTime.now().toUtc();

    List<DateTime> dateTimes = worldBoss.times
      .map((t) {
        List<int> timeParts = t.split(':').map((p) => int.parse(p)).toList();
        return DateTime.utc(
          now.year,
          now.month,
          now.day,
          timeParts[0],
          timeParts[1]
        ).toLocal();
      })
      .toList();

    dateTimes.sort((a, b) => a.hour.compareTo(b.hour));

    return dateTimes;
  }
}