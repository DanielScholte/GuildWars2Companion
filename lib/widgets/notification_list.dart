import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/blocs/notification/notification_bloc.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:intl/intl.dart';

class CompanionNotificationList extends StatefulWidget {
  final String eventId;

  CompanionNotificationList({
    this.eventId
  });

  @override
  _CompanionNotificationListState createState() => _CompanionNotificationListState();
}

class _CompanionNotificationListState extends State<CompanionNotificationList> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<NotificationBloc>(context).add(RemoveExpiredNotificationsEvent());

    _timer = Timer.periodic(	
      Duration(seconds: 10),	
      (Timer timer) => BlocProvider.of<NotificationBloc>(context).add(RemoveExpiredNotificationsEvent()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final Configuration configuration = (state as LoadedConfiguration).configuration;
        final DateFormat timeFormat = configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

        return BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is ScheduledNotificationsState) {
              List<ScheduledNotification> scheduledNotifications = widget.eventId != null 
                ? state.scheduledNotifications.where((n) => n.eventId == widget.eventId).toList()
                : state.scheduledNotifications;

              if (scheduledNotifications.isEmpty && widget.eventId != null) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'No notifications scheduled for this event',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (scheduledNotifications.isEmpty && widget.eventId == null) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.bellSlash,
                        size: 28,
                      ),
                      Text(
                        'No notifications scheduled',
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: scheduledNotifications
                  .map((n) {
                    String date = DateFormat('yyyy-MM-dd').format(n.spawnDateTime);

                    String before = n.offset.inMinutes > 0 ? '${n.offset.inMinutes} minutes before' : 'When spawning at';

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Remove scheduled notification'),
                              content: Text(
                                'Are you sure that you want to remove this scheduled notification?'
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 18.0
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                FlatButton(
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                      fontSize: 18.0
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    BlocProvider.of<NotificationBloc>(context).add(RemoveScheduledNotificationEvent(n.id));
                                  },
                                )
                              ],
                            );
                          }
                        ),
                          // 
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: Row(
                            children: [
                              if (n.type == NotificationType.DAILY)
                                Container(
                                  width: 28,
                                  child: Icon(
                                    Icons.repeat,
                                    size: 28,
                                  ),
                                )
                              else
                                Container(
                                  width: 28,
                                  child: Icon(
                                    FontAwesomeIcons.solidBell,
                                    size: 20,
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.eventId == null)
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
                              Icon(
                                FontAwesomeIcons.trash,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
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