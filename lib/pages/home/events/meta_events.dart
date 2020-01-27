import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/event/event_bloc.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/error.dart';

import 'meta_event.dart';

class MetaEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.green),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Meta Events',
          color: Colors.green,
          foregroundColor: Colors.white,
          elevation: 4.0,
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
                color: Colors.white,
                onRefresh: () async {
                  BlocProvider.of<EventBloc>(context).add(LoadEventsEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: ListView(
                  children: state.events
                    .map((e) => CompanionButton(
                      height: 64.0,
                      title: e.name,
                      leading: Image.asset(
                        'assets/button_headers/event_icon.png',
                        height: 48.0,
                        width: 48.0,
                      ),
                      color: GuildWarsUtil.regionColor(e.region),
                      onTap: () {
                        BlocProvider.of<EventBloc>(context).add(LoadEventsEvent(id: e.id));
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MetaEventPage(e)
                        ));
                      },
                    ))
                    .toList(),
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
}