import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/models/event_segment.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/content_elevation.dart';
import 'package:guildwars2_companion/features/event/models/notification.dart';
import 'package:guildwars2_companion/features/event/widgets/notification_list_card.dart';
import 'package:guildwars2_companion/features/event/widgets/times_card.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/world_boss/widgets/stats_card.dart';

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
              _EventHeader(
                segment: segment,
                sequence: sequence,
              ),
            if (this.worldBoss != null)
              _WorldBossHeader(
                segment: segment,
                worldBoss: worldBoss,
              ),
            Expanded(
              child: CompanionListView(
                children: <Widget>[
                  if (this.worldBoss != null)
                    WorldBossStatsCard(
                      worldBoss: worldBoss,
                    ),
                  EventTimesCard(
                    segment: segment,
                    timeColor: worldBoss != null ? worldBoss.color : Colors.orange,
                  ),
                  EventNotificationListCard(
                    eventId: segment.id,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  final MetaEventSegment segment;
  final MetaEventSequence sequence;

  const _EventHeader({
    @required this.segment,
    @required this.sequence,
  });
  
  @override
  Widget build(BuildContext context) {
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
              Assets.buttonHeaderEventIcon,
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
}

class _WorldBossHeader extends StatelessWidget {
  final WorldBoss worldBoss;
  final MetaEventSegment segment;

  const _WorldBossHeader({
    @required this.worldBoss,
    @required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionHeader(
      color: worldBoss.color,
      wikiName: worldBoss.name,
      wikiRequiresEnglish: true,
      includeBack: true,
      eventSegment: segment..type = EventType.WORLD_BOSS,
      child: Column(
        children: <Widget>[
          CompanionContentElevation(
            radius: BorderRadius.circular(7.0),
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Hero(
                tag: worldBoss.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(Assets.getWorldBossAsset(worldBoss.id)),
                ),
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
}