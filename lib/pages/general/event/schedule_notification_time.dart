import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/pages/general/event/schedule_notification_offset.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
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
              child: widget.notificationType == NotificationType.SINGLE ? _buildSingleOptions(context) : _buildDailyOptions(context),
            )
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (widget.notificationType == NotificationType.SINGLE && _time.isBefore(DateTime.now())) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
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

  Widget _buildSingleOptions(BuildContext context) {
    return Column(
      children: [
        _buildDateSelector(context),
        _buildTimeSelector(context)
      ],
    );
  }

  Widget _buildDailyOptions(BuildContext context) {
    return Column(
      children: [
        _buildTimeSelector(context),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();

        final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: now,
          lastDate: now.add(Duration(days: 7))
        );

        if (picked != null) {
          setState(() {
            _date = picked;

            _time = DateTime(
              _date.year,
              _date.month,
              _date.day,
              _time.hour,
              _time.minute
            );
          });
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
                      text: DateFormat('yyyy-MM-dd').format(_date),
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

  Widget _buildTimeSelector(BuildContext context) {
    Color selectedColor = Theme.of(context).brightness == Brightness.light ? Colors.red : Colors.white38;
    Color unselectedColor = Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.white12;
    Color disabledColor = Theme.of(context).brightness == Brightness.light ? Colors.black26 : Colors.black;

    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final Configuration configuration = (state as LoadedConfiguration).configuration;
        final DateFormat timeFormat = configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: widget.notificationType == NotificationType.SINGLE ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
                  children: _times
                    .map((t) {
                      DateTime time = DateTime(
                        _date.year,
                        _date.month,
                        _date.day,
                        t.hour,
                        t.minute
                      );

                      bool disabled = widget.notificationType == NotificationType.SINGLE ? time.isBefore(DateTime.now()) : false;

                      return GestureDetector(
                        onTap: () {
                          if (!disabled) {
                            setState(() => _time = time);
                          }
                        },
                        child: Chip(
                          backgroundColor: disabled ? disabledColor : time == _time ? selectedColor : unselectedColor,
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