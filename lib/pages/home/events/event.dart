import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {

  final MetaEventSequence sequence;
  final MetaEventSegment segment;

  final DateFormat timeFormat = DateFormat.Hm();

  EventPage({
    this.sequence,
    this.segment
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.orange),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: <Widget>[
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
      color: Colors.orange,
      wikiName: segment.name,
      includeBack: true,
      child: Column(
        children: <Widget>[
          Hero(
            tag: segment.name,
            child: Image.asset(
              'assets/button_headers/event_icon.png',
              height: 48.0,
              width: 48.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              segment.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            sequence.name,
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

  Widget _buildTimes() {
    List<DateTime> times = segment.times.map((d) => d.toLocal()).toList();
    times.sort((a, b) => a.hour.compareTo(b.hour));

    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Spawn Times',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 16.0,
            runSpacing: 4.0,
            children: times
              .map((t) => Chip(
                backgroundColor: Colors.orange,
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
}