import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/expandable_card.dart';
import 'package:guildwars2_companion/features/meta_event/bloc/event_bloc.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:timer_builder/timer_builder.dart';

import 'meta_event.dart';

class MetaEventsPage extends StatefulWidget {
  @override
  _MetaEventsPageState createState() => _MetaEventsPageState();
}

class _MetaEventsPageState extends State<MetaEventsPage> {
  Timer _timer;
  bool _canRefresh = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.green,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Meta Events',
          color: Colors.green,
        ),
        body: BlocBuilder<MetaEventBloc, MetaEventState>(
          builder: (context, state) {
            if (state is ErrorMetaEventsState) {
              return Center(
                child: CompanionError(
                  title: 'the meta events',
                  onTryAgain: () =>
                    BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent()),
                ),
              );
            }

            if (state is LoadedMetaEventsState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: <Widget>[
                    _MasteryCategoryButton(
                      name: 'Tyria',
                      region: 'Tyria',
                      sequences: state.events,
                      onRequiresRefresh: () => refreshMetaEvents(),
                    ),
                    _MasteryCategoryButton(
                      name: 'Heart of Thorns',
                      region: 'Maguuma',
                      sequences: state.events,
                      onRequiresRefresh: () => refreshMetaEvents(),
                    ),
                    _MasteryCategoryButton(
                      name: 'Path of Fire',
                      region: 'Desert',
                      sequences: state.events,
                      onRequiresRefresh: () => refreshMetaEvents(),
                    ),
                    _MasteryCategoryButton(
                      name: 'Icebrood Saga',
                      region: 'Icebrood',
                      sequences: state.events,
                      onRequiresRefresh: () => refreshMetaEvents(),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void refreshMetaEvents() {
    if (!_canRefresh) {
      return;
    }

    _canRefresh = false;
    _timer = Timer(
      Duration(seconds: 30),	
      () => _canRefresh = true	
    );

    BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent());
  }
}

class _MasteryCategoryButton extends StatelessWidget {
  final String name;
  final String region;
  final List<MetaEventSequence> sequences;
  final Function onRequiresRefresh;

  _MasteryCategoryButton({
    @required this.name,
    @required this.region,
    @required this.sequences,
    @required this.onRequiresRefresh
  });

  @override
  Widget build(BuildContext context) {
    return CompanionExpandableCard(
      title: name,
      foreground: Colors.white,
      background: Theme.of(context).brightness == Brightness.light ? GuildWarsUtil.regionColor(region) : Colors.white30,
      child: Padding(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Column(
          children: sequences
            .where((s) => s.region == region)
            .map((sequence) => TimerBuilder.periodic(Duration(seconds: 1),
              builder: (context) {
                DateTime now = DateTime.now();
            
                if (sequence.segments.any((segment) => segment.time.add(segment.duration).isBefore(now))) {
                  onRequiresRefresh();
                }

                return CompanionButton(
                  height: 72.0,
                  title: sequence.name,
                  leading: Image.asset(
                    Assets.buttonHeaderEventIcon,
                    height: 48.0,
                    width: 48.0,
                  ),
                  subtitleWidgets: sequence.segments
                    .where((s) => s.name != null)
                    .take(2)
                    .map((segment) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            segment.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                              fontSize: 16.0,
                            )
                          ),
                        ),
                        Container(width: 8),
                        if (segment.time.isBefore(now))
                          Text(
                            'Active',
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                              fontSize: 16.0,
                            )
                          )
                        else
                          Text(
                            GuildWarsUtil.durationToString(segment.time.difference(now)),
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                              fontSize: 16.0,
                            )
                          )
                      ],
                    ))
                    .toList(),
                  color: Colors.white,
                  foregroundColor: Colors.black,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MetaEventPage(sequence)
                    ));
                  },
                );
              }
            ))
            .toList()
        ),
      ),
    );
  }
}