import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:intl/intl.dart';

class WorldBossPage extends StatelessWidget {

  final WorldBoss worldBoss;

  final DateFormat timeFormat = DateFormat.Hm();

  WorldBossPage(this.worldBoss);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: '',
        color: worldBoss.color,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          _buildHeader(),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: worldBoss.color),
              child: ListView(
                children: <Widget>[
                  _buildStats(),
                  _buildTimes()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: worldBoss.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8.0,
          ),
        ],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0))
      ),
      margin: EdgeInsets.only(bottom: 16.0),
      width: double.infinity,
      child: SafeArea(
        minimum: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
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
          _buildInfoRow(
            header: 'Level',
            text: worldBoss.level.toString()
          ),
          _buildInfoRow(
            header: 'Map',
            text: worldBoss.location
          ),
          _buildInfoRow(
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

  Widget _buildInfoRow({@required String header, String text, Widget widget }) {
    return Container(
      width: 400.0,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            ),
          ),
          if (widget != null)
            widget
          else
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0
              ),
            )
        ],
      ),
    );
  }
}