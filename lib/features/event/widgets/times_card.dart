import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/models/event_segment.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:intl/intl.dart';

class EventTimesCard extends StatelessWidget {
  final MetaEventSegment segment;
  final Color timeColor;

  EventTimesCard({
    @required this.segment,
    @required this.timeColor
  });

  @override
  Widget build(BuildContext context) {
    List<DateTime> times = segment.times.toList();
    times.sort((a, b) => a.hour.compareTo(b.hour));

    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, state) {
        final DateFormat timeFormat = state.configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

        return CompanionInfoCard(
          title: 'Spawn Times',
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 16.0,
            runSpacing: 4.0,
            children: times
              .map((t) => Chip(
                backgroundColor: Theme.of(context).brightness == Brightness.light ? timeColor : Colors.white12,
                label: Text(
                  timeFormat.format(t),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.white
                  ),
                ),
              ))
              .toList()
          ),
        );
      },
    );
  }
}