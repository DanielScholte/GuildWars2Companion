import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/features/meta_event/bloc/event_bloc.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';
import 'package:guildwars2_companion/core/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/expandable_header.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';

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
                    _buildCategory(context, 'Tyria', 'Tyria', state.events),
                    _buildCategory(context, 'Heart of Thorns', 'Maguuma', state.events),
                    _buildCategory(context, 'Path of Fire', 'Desert', state.events),
                    _buildCategory(context, 'Icebrood Saga', 'Icebrood', state.events),
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
                  BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent(id: s.id));
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