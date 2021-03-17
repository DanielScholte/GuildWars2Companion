import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/models/event_segment.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/features/event/pages/event.dart';
import 'package:guildwars2_companion/features/meta_event/bloc/event_bloc.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class MetaEventPage extends StatelessWidget {
  final MetaEventSequence metaEventSequence;

  MetaEventPage(this.metaEventSequence);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: GuildWarsUtil.regionColor(metaEventSequence.region),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: metaEventSequence.name,
          color: GuildWarsUtil.regionColor(metaEventSequence.region),
        ),
        body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, configurationState) {
            final DateFormat timeFormat = configurationState.configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

            return BlocBuilder<MetaEventBloc, MetaEventState>(
              builder: (context, state) {
                if (state is ErrorMetaEventsState) {
                  return Center(
                    child: CompanionError(
                      title: 'the meta event',
                      onTryAgain: () =>
                        BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent()),
                    ),
                  );
                }

                if (state is LoadedMetaEventsState) {
                  MetaEventSequence _sequence = state.events.firstWhere((e) => e.id == metaEventSequence.id);

                  return RefreshIndicator(
                    backgroundColor: Theme.of(context).accentColor,
                    color: Theme.of(context).cardColor,
                    onRefresh: () async {
                      BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent(id: metaEventSequence.id));
                      await Future.delayed(Duration(milliseconds: 200), () {});
                    },
                    child: CompanionListView(
                      children: _sequence.segments
                        .where((s) => s.name != null)
                        .map((segment) => _EventButton(
                          segment: segment,
                          sequence: metaEventSequence,
                          timeFormat: timeFormat,
                        ))
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
}

class _EventButton extends StatelessWidget {
  final MetaEventSequence sequence;
  final MetaEventSegment segment;
  final DateFormat timeFormat;

  _EventButton({
    @required this.segment,
    @required this.sequence,
    @required this.timeFormat
  });

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      color: Colors.orange,
      title: segment.name,
      height: 64.0,
      hero: segment.name,
      leading: Image.asset(
        'assets/images/button_headers/event_icon.png',
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

                if (segment.time.add(segment.duration).isBefore(now)) {
                  BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent(id: sequence.id));
                }

                if (segment.time.isBefore(now)) {
                  return Text(
                    'Active',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white,
                    ),
                  );
                }
                  
                return Text(
                  GuildWarsUtil.durationToString(segment.time.difference(DateTime.now())),
                  style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white
                  ),
                );
              },
            ),
            Text(
              timeFormat.format(segment.time),
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
          sequence: sequence,
        )
      )),
    );
  }
}