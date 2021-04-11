import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/features/event/pages/event.dart';
import 'package:guildwars2_companion/features/world_boss/bloc/world_boss_bloc.dart';
import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class WorldBossesPage extends StatefulWidget {
  @override
  _WorldBossesPageState createState() => _WorldBossesPageState();
}

class _WorldBossesPageState extends State<WorldBossesPage> {
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
      lightColor: Colors.deepPurple,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'World Bosses',
          color: Colors.deepPurple,
        ),
        body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, configurationState) {
            final DateFormat timeFormat = configurationState.configuration.timeNotation24Hours ? DateFormat.Hm() : DateFormat.jm();

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
                        .map((w) => _Row(
                          worldBoss: w,
                          timeFormat: timeFormat,
                          onRequiresRefresh: () {
                            if (!_canRefresh) {
                              return;
                            }

                            _canRefresh = false;
                            _timer = Timer(
                              Duration(seconds: 30),	
                              () => _canRefresh = true	
                            );

                            BlocProvider.of<WorldBossBloc>(context).add(LoadWorldbossesEvent(false, null));
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
            );
          }
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final WorldBoss worldBoss;
  final DateFormat timeFormat;
  final Function onRequiresRefresh;

  _Row({
    @required this.worldBoss,
    @required this.timeFormat,
    @required this.onRequiresRefresh
  });

  @override
  Widget build(BuildContext context) {
    DateTime time = worldBoss.segment.time;

    return CompanionButton(
      color: GuildWarsUtil.getWorldBossColor(hardDifficulty: worldBoss.hardDifficulty),
      title: worldBoss.name,
      hero: worldBoss.id,
      leading: Stack(
        children: <Widget>[
          Image.asset(Assets.getWorldBossAsset(worldBoss.id)),
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

                if (time.add(worldBoss.segment.duration).isBefore(now)) {
                  onRequiresRefresh();
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