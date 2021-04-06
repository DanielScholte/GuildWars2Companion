import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/models/event_segment.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/features/event/models/notification.dart';
import 'package:guildwars2_companion/features/event/pages/schedule_notification_offset.dart';
import 'package:intl/intl.dart';

class ScheduleNotificationTimePage extends StatefulWidget {
  final MetaEventSegment segment;
  final NotificationType notificationType;

  ScheduleNotificationTimePage({
    @required this.segment,
    @required this.notificationType,
  });

  @override
  _ScheduleNotificationTimePageState createState() => _ScheduleNotificationTimePageState();
}

class _ScheduleNotificationTimePageState extends State<ScheduleNotificationTimePage> {
  List<DateTime> _times;

  DateTime _date;
  DateTime _time;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();

    _times = widget.segment.times.toList();
    _times.sort((a, b) => a.hour.compareTo(b.hour));

    _date = DateTime(
      now.year,
      now.month,
      now.day
    );

    _time = widget.segment.times.firstWhere((t) => t.isAfter(now), orElse: () => widget.segment.time);
  }

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.red,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Choose a${widget.notificationType == NotificationType.SINGLE ? " date and" : ""} spawn time',
          color: Colors.red,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Column(
                children: [
                  if (widget.notificationType == NotificationType.SINGLE)
                    _DateSelector(
                      selectedDate: _date,
                      onSelect: (date) {
                        setState(() {
                          _date = date;

                          _time = DateTime(
                            _date.year,
                            _date.month,
                            _date.day,
                            _time.hour,
                            _time.minute
                          );
                        });
                      },
                    ),
                  _TimeSelector(
                    selectedTime: _time,
                    baseDate: _date,
                    times: _times,
                    type: widget.notificationType,
                    onSelect: (time) {
                      setState(() => _time = time);
                    },
                  )
                ],
              )
            )
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (widget.notificationType == NotificationType.SINGLE && _time.isBefore(DateTime.now())) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please select a date or time.')
              ));
              return;
            }

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScheduleNotificationOffsetPage(
                segment: widget.segment,
                notificationType: widget.notificationType,
                spawnDateTime: _time,
              )
            ));
          },
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

class _DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelect;

  _DateSelector({
    @required this.selectedDate,
    @required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();

        final DateTime date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: now,
          lastDate: now.add(Duration(days: 7))
        );

        if (date != null) {
          onSelect(date);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'Date: ',
                  style: Theme.of(context).textTheme.headline2.copyWith(
                    fontWeight: FontWeight.w500
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: TextStyle(
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                )
              ),
            ),
            Icon(
              FontAwesomeIcons.calendarDay,
              size: 20.0,
            )
          ],
        ),
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  final DateTime selectedTime;
  final DateTime baseDate;
  final List<DateTime> times;
  final NotificationType type;
  final Function(DateTime) onSelect;

  _TimeSelector({
    @required this.selectedTime,
    @required this.baseDate,
    @required this.times,
    @required this.type,
    @required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).brightness == Brightness.light ? Colors.red : Colors.white38;
    Color unselectedColor = Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.white12;
    Color disabledColor = Theme.of(context).brightness == Brightness.light ? Colors.black26 : Colors.black;

    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final DateFormat timeFormat = state.configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: type == NotificationType.SINGLE ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Time:',
                    style: Theme.of(context).textTheme.headline2
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 16.0,
                  runSpacing: 4.0,
                  children: times
                    .map((t) {
                      DateTime time = DateTime(
                        baseDate.year,
                        baseDate.month,
                        baseDate.day,
                        t.hour,
                        t.minute
                      );

                      bool disabled = type == NotificationType.SINGLE ? time.isBefore(DateTime.now()) : false;

                      return GestureDetector(
                        onTap: () {
                          if (!disabled) {
                            onSelect(time);
                          }
                        },
                        child: Chip(
                          backgroundColor: disabled ? disabledColor : time == selectedTime ? selectedColor : unselectedColor,
                          padding: EdgeInsets.all(8.0),
                          label: Text(
                            timeFormat.format(time),
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                        ),
                      );
                    })
                    .toList()
                )
              ],
            ),
          ),
        );
      }
    );
  }
}