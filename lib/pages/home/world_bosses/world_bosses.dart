import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/blocs/world_boss/bloc.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/pages/general/event/event.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class WorldBossesPage extends StatefulWidget {
  @override
  _WorldBossesPageState createState() => _WorldBossesPageState();
}

class _WorldBossesPageState extends State<WorldBossesPage> {
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
      lightColor: Colors.deepPurple,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'World Bosses',
          color: Colors.deepPurple,
        ),
        body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, configurationState) {
            final Configuration configuration = (configurationState as LoadedConfiguration).configuration;
            final DateFormat timeFormat = configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

            return BlocBuilder<WorldBossBloc, WorldBossState>(
              builder: (context, state) {
                if (state is ErrorWorldbossesState) {
                  return Center(
                    child: CompanionError(
                      title: 'the world bosses',
                      onTryAgain: () =>
                        BlocProvider.of<WorldBossBloc>(context).add(LoadWorldbossesEvent(true, null)),
                    ),
                  );
                }

                if (state is LoadedWorldbossesState) {
                  return RefreshIndicator(
                    backgroundColor: Theme.of(context).accentColor,
                    color: Theme.of(context).cardColor,
                    onRefresh: () async {
                      BlocProvider.of<WorldBossBloc>(context).add(LoadWorldbossesEvent(true, null));
                      await Future.delayed(Duration(milliseconds: 200), () {});
                    },
                    child: CompanionListView(
                      children: state.worldBosses
                        .map((w) => _buildWorldbossRow(context, timeFormat, w))
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
              
  Widget _buildWorldbossRow(BuildContext context, DateFormat timeFormat, WorldBoss worldBoss) {
    DateTime time = worldBoss.segment.time;

    return CompanionButton(
      color: worldBoss.color,
      title: worldBoss.name,
      hero: worldBoss.id,
      leading: Stack(
        children: <Widget>[
          Image.asset('assets/world_bosses/${worldBoss.id}.jpg'),
          if (worldBoss.completed)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white60,
              alignment: Alignment.center,
              child: Icon(
                FontAwesomeIcons.check,
                color: Colors.black87,
                size: 38.0,
              ),
            ),
        ],
      ),
      subtitles: [
        worldBoss.location,
      ],
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

                if (time.add(worldBoss.segment.duration).isBefore(now) && _refreshTimeout == 0) {
                  _refreshTimeout = 30;
                  BlocProvider.of<WorldBossBloc>(context).add(LoadWorldbossesEvent(false, null));
                }

                if (isActive) {
                  return Text(
                    'Active',
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white
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
          segment: worldBoss.segment,
          worldBoss: worldBoss,
        )
      )),
    );
  }
}
