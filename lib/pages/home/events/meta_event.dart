import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/blocs/event/event_bloc.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../general/event/event.dart';

class MetaEventPage extends StatefulWidget {

  final MetaEventSequence metaEventSequence;

  MetaEventPage(this.metaEventSequence);

  @override
  _MetaEventPageState createState() => _MetaEventPageState();
}

class _MetaEventPageState extends State<MetaEventPage> {
  Timer _timer;
  int _refreshTimeout = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(	
      Duration(seconds: 1),	
      (Timer timer) {	
        if (_refreshTimeout > 0) {	
          _refreshTimeout--;	
        }
      },	
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: GuildWarsUtil.regionColor(widget.metaEventSequence.region),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: widget.metaEventSequence.name,
          color: GuildWarsUtil.regionColor(widget.metaEventSequence.region),
        ),
        body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, configurationState) {
            final Configuration configuration = (configurationState as LoadedConfiguration).configuration;
            final DateFormat timeFormat = configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

            return BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is ErrorEventsState) {
                  return Center(
                    child: CompanionError(
                      title: 'the meta event',
                      onTryAgain: () =>
                        BlocProvider.of<EventBloc>(context).add(LoadEventsEvent()),
                    ),
                  );
                }

                if (state is LoadedEventsState) {
                  MetaEventSequence _sequence = state.events.firstWhere((e) => e.id == widget.metaEventSequence.id);

                  return RefreshIndicator(
                    backgroundColor: Theme.of(context).accentColor,
                    color: Theme.of(context).cardColor,
                    onRefresh: () async {
                      BlocProvider.of<EventBloc>(context).add(LoadEventsEvent(id: widget.metaEventSequence.id));
                      await Future.delayed(Duration(milliseconds: 200), () {});
                    },
                    child: CompanionListView(
                      children: _sequence.segments
                        .where((e) => e.name != null)
                        .map((e) => _buildEventButton(context, timeFormat, e))
                        .toList(),
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
        ),
      ),
    );
  }

  Widget _buildEventButton(BuildContext context, DateFormat timeFormat, MetaEventSegment segment) {
    DateTime time = segment.time;

    return CompanionButton(
      color: Colors.orange,
      title: segment.name,
      height: 64.0,
      hero: segment.name,
      leading: Image.asset(
        'assets/button_headers/event_icon.png',
        height: 48.0,
        width: 48.0,
      ),
      trailing: Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TimerBuilder.periodic(Duration(seconds: 1),
              builder: (context) {
                DateTime now = DateTime.now();

                bool isActive = time.isBefore(now);

                if (time.add(segment.duration).isBefore(now)) {
                  _refreshTimeout = 30;
                  BlocProvider.of<EventBloc>(context).add(LoadEventsEvent(id: widget.metaEventSequence.id));
                }

                if (isActive) {
                  return Text(
                    'Active',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white,
                    ),
                  );
                }
                  
                return Text(
                  GuildWarsUtil.durationToString(time.difference(DateTime.now())),
                  style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white
                  ),
                );
              },
            ),
            Text(
              timeFormat.format(time),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white
              ),
            )
          ],
        ),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        settings: RouteSettings(name: '/event'),
        builder: (context) => EventPage(
          segment: segment,
          sequence: widget.metaEventSequence,
        )
      )),
    );
  }
}