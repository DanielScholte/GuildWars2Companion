import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/pages/general/event/schedule_notification_time.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/tip.dart';
import 'package:guildwars2_companion/widgets/warning.dart';

class ScheduleNotificationTypePage extends StatefulWidget {
  final MetaEventSegment segment;

  ScheduleNotificationTypePage({
    @required this.segment
  });

  @override
  _ScheduleNotificationTypePageState createState() => _ScheduleNotificationTypePageState();
}

class _ScheduleNotificationTypePageState extends State<ScheduleNotificationTypePage> {
  NotificationType _notificationType = NotificationType.SINGLE;

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.red,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Choose a notification type',
          color: Colors.red,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...NotificationType.values
                  .map((e) => RadioListTile(
                    groupValue: _notificationType,
                    value: e,
                    title: Text(
                      e == NotificationType.DAILY ? 'Daily notification' : 'One-time notification',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    subtitle: Text(
                      e == NotificationType.DAILY ? 'Receive a daily notification at the selected time' : 'Receive a single notification at the selected date and time',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onChanged: (t) => setState(() => _notificationType = t),
                  ))
                  .toList(),
                Container(height: 8.0,),
                CompanionTip(
                  tip: 'You can plan multiple notifications for a single event or world boss.',
                ),
                CompanionWarning(
                  warning: "If you're experiencing issues with not receiving the one-time notifications, please disable battery management for this app.",
                  ios: false,
                ),
                CompanionWarning(
                  warning: "If you're experiencing significantly delayed daily notifications, please use the one-time option.",
                  ios: false,
                )
              ],
            )
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScheduleNotificationTimePage(
              segment: widget.segment,
              notificationType: _notificationType,
            )
          )),
          label: Text(
            'Next'
          ),
          icon: Icon(
            FontAwesomeIcons.arrowRight,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}