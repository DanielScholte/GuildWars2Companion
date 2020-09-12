import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_row.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';
import 'package:guildwars2_companion/widgets/notification_list.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {

  final MetaEventSequence sequence;
  final MetaEventSegment segment;
  final WorldBoss worldBoss;

  EventPage({
    @required this.segment,
    this.sequence,
    this.worldBoss,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.orange,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            if (this.sequence != null)
              _buildEventHeader(context),
            if (this.worldBoss != null)
              _buildWorldBossHeader(context),
            Expanded(
              child: CompanionListView(
                children: <Widget>[
                  if (this.worldBoss != null)
                    _buildWorldBossStats(context),
                  _buildTimes(context),
                  _buildNotificationList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorldBossHeader(BuildContext context) {
    return CompanionHeader(
      color: worldBoss.color,
      wikiName: worldBoss.name,
      wikiRequiresEnglish: true,
      includeBack: true,
      eventSegment: segment..type = EventType.WORLD_BOSS,
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
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            worldBoss.location,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventHeader(BuildContext context) {
    return CompanionHeader(
      color: Colors.orange,
      wikiName: segment.name,
      wikiRequiresEnglish: true,
      includeBack: true,
      eventSegment: segment..type = EventType.META_EVENT,
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
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            sequence.name,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorldBossStats(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Stats',
              style: Theme.of(context).textTheme.headline2,
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
    List<DateTime> times = segment.times.toList();
    times.sort((a, b) => a.hour.compareTo(b.hour));

    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final Configuration configuration = (state as LoadedConfiguration).configuration;
        final DateFormat timeFormat = configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

        Color lightColor = worldBoss != null ? worldBoss.color : Colors.orange;
        
        return CompanionCard(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Spawn Times',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 16.0,
                runSpacing: 4.0,
                children: times
                  .map((t) => Chip(
                    backgroundColor: Theme.of(context).brightness == Brightness.light ? lightColor : Colors.white12,
                    label: Text(
                      timeFormat.format(t),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white
                      ),
                    ),
                  ))
                  .toList()
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    return CompanionCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Scheduled notifications',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            CompanionNotificationList(
              eventId: segment.id,
            )
          ],
        ),
      ),
    );
  }
}