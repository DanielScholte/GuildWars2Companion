import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/event/event_bloc.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/expandable_header.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

import 'meta_event.dart';

class MetaEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.green,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Meta Events',
          color: Colors.green,
        ),
        body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is ErrorEventsState) {
              return Center(
                child: CompanionError(
                  title: 'the meta events',
                  onTryAgain: () =>
                    BlocProvider.of<EventBloc>(context).add(LoadEventsEvent()),
                ),
              );
            }

            if (state is LoadedEventsState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<EventBloc>(context).add(LoadEventsEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: <Widget>[
                    _buildCategory(context, 'Tyria', 'Tyria', state.events),
                    _buildCategory(context, 'Heart of Thorns', 'Maguuma', state.events),
                    _buildCategory(context, 'Path of Fire', 'Desert', state.events),
                    _buildCategory(context, 'The Icebrood Saga', 'Icebrood', state.events),
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

  Widget _buildCategory(BuildContext context, String name, String region, List<MetaEventSequence> sequences) {
    return CompanionCard(
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).brightness == Brightness.light ? GuildWarsUtil.regionColor(region) : Colors.white30,
      child: CompanionExpandableHeader(
        header: name,
        foreground: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Column(
            children: sequences
              .where((s) => s.region == region)
              .map((s) => CompanionButton(
                height: 64.0,
                title: s.name,
                leading: Image.asset(
                  'assets/button_headers/event_icon.png',
                  height: 48.0,
                  width: 48.0,
                ),
                color: Colors.white,
                foregroundColor: Colors.black,
                onTap: () {
                  BlocProvider.of<EventBloc>(context).add(LoadEventsEvent(id: s.id));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MetaEventPage(s)
                  ));
                },
              ))
              .toList()
          ),
        ),
      ),
    );
  }
}