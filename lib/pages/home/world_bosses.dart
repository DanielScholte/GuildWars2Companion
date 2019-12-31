import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/world_bosses/bloc.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';
import 'package:intl/intl.dart';

class WorldbossesPage extends StatefulWidget {
  @override
  _WorldbossesPageState createState() => _WorldbossesPageState();
}

class _WorldbossesPageState extends State<WorldbossesPage> {

  final DateFormat timeFormat = DateFormat.Hm();

  Timer _timer;
  int _refreshTimeout = 0;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<WorldbossesBloc>(context).add(LoadWorldbossesEvent(true));

    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_refreshTimeout > 0) {
          _refreshTimeout--;
        }

        setState(() {});
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
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'World Bosses',
        color: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: BlocBuilder<WorldbossesBloc, WorldbossesState>(
        builder: (context, state) {
          if (state is LoadedWorldbossesState) {
            DateTime now = DateTime.now();

            if (state.worldBosses.any((w) => w.refreshTime.toLocal().isBefore(now))
              && _refreshTimeout == 0) {
              _refreshTimeout = 30;
              BlocProvider.of<WorldbossesBloc>(context).add(LoadWorldbossesEvent(false));
            }

            return ListView(
              children: state.worldBosses
                .map((w) => _buildWorldbossRow(context, w))
                .toList(),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
              
  Widget _buildWorldbossRow(BuildContext context, WorldBoss worldBoss) {
    bool isActive = worldBoss.dateTime.toLocal().isBefore(DateTime.now());

    return CompanionFullButton(
      color: Colors.blue,
      title: worldBoss.name,
      loading: true,
      subtitles: [
        worldBoss.location,
      ],
      trailing: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (isActive)
              Text(
                'Active',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              )
            else
              Text(
                _printDuration(worldBoss.dateTime.toLocal().difference(DateTime.now())),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
            Text(
              timeFormat.format(worldBoss.dateTime.toLocal()),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours == 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}