import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';
import 'package:intl/intl.dart';

class WorldBossPage extends StatelessWidget {

  final WorldBoss worldBoss;

  final DateFormat timeFormat = DateFormat.Hm();

  WorldBossPage(this.worldBoss);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: worldBoss.color),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  _buildStats(),
                  _buildTimes()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CompanionHeader(
      color: worldBoss.color,
      wikiName: worldBoss.name,
      includeBack: true,
      child: Column(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.asset('assets/world_bosses/${worldBoss.id}.jpg'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              worldBoss.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            worldBoss.location,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Stats',
              style: TextStyle(
                fontSize: 18.0
              ),
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

  Widget _buildTimes() {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Spawn Times',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 16.0,
            runSpacing: 4.0,
            children: _getSpawnTimes(worldBoss.times)
              .map((t) => Chip(
                backgroundColor: worldBoss.color,
                label: Text(
                  timeFormat.format(t),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                  ),
                ),
              ))
              .toList()
          )
        ],
      ),
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