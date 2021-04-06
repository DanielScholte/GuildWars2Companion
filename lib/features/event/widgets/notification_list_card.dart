import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/event/widgets/notification_list.dart';

class EventNotificationListCard extends StatelessWidget {
  final String eventId;

  EventNotificationListCard({
    this.eventId
  });

  @override
  Widget build(BuildContext context) {
    return CompanionInfoCard(
      title: 'Scheduled notifications',
      childPadding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0)
        ),
        child: EventNotificationList(
          eventId: eventId,
        ),
      ),
    );
  }
}