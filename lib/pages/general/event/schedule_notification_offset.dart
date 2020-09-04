import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/notification/notification_bloc.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class ScheduleNotificationOffsetPage extends StatefulWidget {
  final MetaEventSegment segment;
  final NotificationType notificationType;
  final DateTime spawnDateTime;

  ScheduleNotificationOffsetPage({
    @required this.segment,
    @required this.notificationType,
    @required this.spawnDateTime,
  });

  @override
  _ScheduleNotificationOffsetPageState createState() => _ScheduleNotificationOffsetPageState();
}

class _ScheduleNotificationOffsetPageState extends State<ScheduleNotificationOffsetPage> {
  Duration _offset = Duration.zero;

  @override
  Widget build(BuildContext context) {
    List<Duration> durations = [
      Duration.zero,
      Duration(minutes: 5),
      Duration(minutes: 10),
      Duration(minutes: 15),
      Duration(minutes: 20),
      Duration(minutes: 30),
      Duration(minutes: 45),
      Duration(minutes: 60),
    ];

    if (widget.notificationType == NotificationType.SINGLE) {
      DateTime now = DateTime.now();

      durations = durations
        .where((d) => widget.spawnDateTime.subtract(d).isAfter(now))
        .toList();
    }

    return CompanionAccent(
      lightColor: Colors.red,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Choose a notification time',
          color: Colors.red,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Column(
                children: durations
                  .map((d) => RadioListTile(
                    groupValue: _offset,
                    value: d,
                    title: Text(
                      d.inMinutes == 0 ? 'At spawn time' : '${d.inMinutes} minutes before spawning',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    onChanged: (d) => setState(() => _offset = d),
                  ))
                  .toList(),
              )
            )
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            BlocProvider.of<NotificationBloc>(context).add(ScheduleNotificationEvent(ScheduledNotification(
              eventId: widget.segment.id,
              eventName: widget.segment.name,
              eventType: widget.segment.type,
              type: widget.notificationType,
              spawnDateTime: widget.spawnDateTime,
              offset: _offset
            )));

            Navigator.of(context).popUntil(ModalRoute.withName("/event"));
          },
          label: Text(
            'Add notification'
          ),
          icon: Icon(
            FontAwesomeIcons.plus,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}