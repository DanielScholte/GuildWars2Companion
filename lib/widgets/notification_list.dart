import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/blocs/notification/notification_bloc.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:intl/intl.dart';

class CompanionNotificationList extends StatelessWidget {
  final String eventId;

  CompanionNotificationList({
    this.eventId
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final Configuration configuration = (state as LoadedConfiguration).configuration;
        final DateFormat timeFormat = configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

        return BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is ScheduledNotificationsState) {
              List<ScheduledNotification> scheduledNotifications = eventId != null 
                ? state.scheduledNotifications.where((n) => n.eventId == eventId).toList()
                : state.scheduledNotifications;

              if (scheduledNotifications.isEmpty) {
                return Text(
                  'No notifications scheduled' + (eventId != null ? ' for this event' : ''),
                  style: Theme.of(context).textTheme.bodyText1,
                );
              }

              return Column(
                children: scheduledNotifications
                  .map((n) {
                    String date = DateFormat('yyyy-MM-dd').format(n.spawnDateTime);

                    String before = n.offset.inMinutes > 0 ? '${n.offset.inMinutes} minutes before' : 'At';

                    return Row(
                      children: [
                        if (n.type == NotificationType.DAILY)
                          Icon(
                            Icons.repeat,
                            size: 28,
                          )
                        else
                          Icon(
                            Icons.looks_one,
                            size: 28,
                          ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (eventId == null)
                                  Text(
                                    n.eventName,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                if (n.type == NotificationType.DAILY)
                                  Text(
                                    '$before ${timeFormat.format(n.spawnDateTime)}',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  )
                                else
                                  Text(
                                    '$before $date ${timeFormat.format(n.spawnDateTime)}',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  )
                              ],
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.trash,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () => BlocProvider.of<NotificationBloc>(context).add(RemoveScheduledNotificationEvent(n.id)),
                          ),
                        )
                      ],
                    );
                  })
                  .toList(),
              );
            }

            return CircularProgressIndicator();
          },
        );
      }
    );
  }
}