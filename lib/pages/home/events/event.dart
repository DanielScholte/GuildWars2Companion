import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {

  final MetaEventSequence sequence;
  final MetaEventSegment segment;

  EventPage({
    this.sequence,
    this.segment
  });

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.orange,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: CompanionListView(
                children: <Widget>[
                  _buildTimes(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CompanionHeader(
      color: Colors.orange,
      wikiName: segment.name,
      wikiRequiresEnglish: true,
      includeBack: true,
      child: Column(
        children: <Widget>[
          Hero(
            tag: segment.name,
            child: Image.asset(
              'assets/button_headers/event_icon.png',
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

  Widget _buildTimes(BuildContext context) {
    List<DateTime> times = segment.times.map((d) => d.toLocal()).toList();
    times.sort((a, b) => a.hour.compareTo(b.hour));

    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final Configuration configuration = (state as LoadedConfiguration).configuration;
        final DateFormat timeFormat = configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();
        
        return CompanionCard(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Spawn Times',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 16.0,
                runSpacing: 4.0,
                children: times
                  .map((t) => Chip(
                    backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.orange : Colors.white12,
                    label: Text(
                      timeFormat.format(t),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white
                      ),
                    ),
                  ))
                  .toList()
              )
            ],
          ),
        );
      },
    );
  }
}