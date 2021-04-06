import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/features/pvp/bloc/pvp_bloc.dart';
import 'package:guildwars2_companion/features/pvp/models/game.dart';
import 'package:guildwars2_companion/features/pvp/models/standing.dart';
import 'package:guildwars2_companion/features/pvp/models/stats.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/info_box.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/pvp/pages/seasons.dart';

import 'games.dart';

class PvpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Color(0xFF678A9E),
      child: BlocBuilder<PvpBloc, PvpState>(
        builder: (context, state) {
          if (state is ErrorPvpState) {
            return _Placeholder(
              child: Center(
                child: CompanionError(
                  title: 'PvP Statistics',
                  onTryAgain: () =>
                    BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent()),
                ),
              )
            );
          }

          if (state is LoadedPvpState) {
            return _Body(
              pvpStats: state.pvpStats,
              pvpStandings: state.pvpStandings,
              pvpGames: state.pvpGames
            );
          }

          return _Placeholder(
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        },
      )
    );
  }
}

class _Placeholder extends StatelessWidget {
  final Widget child;

  _Placeholder({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'PvP',
        color: Color(0xFF678A9E),
      ),
      body: child,
    );
  }
}

class _Body extends StatelessWidget {
  final PvpStats pvpStats;
  final List<PvpStanding> pvpStandings;
  final List<PvpGame> pvpGames;

  _Body({
    @required this.pvpStats,
    @required this.pvpStandings,
    @required this.pvpGames
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CompanionHeader(
            color: Color(0xFF678A9E),
            includeBack: true,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 48.0,
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: CompanionCachedImage(
                      height: 96.0,
                      imageUrl: pvpStats.rank.icon,
                      color: Colors.white,
                      iconSize: 20,
                      fit: null,
                    ),
                  ),
                ),
                Text(
                  'Rank ${pvpStats.pvpRank}',
                  style: Theme.of(context).textTheme.headline1,
                ),
                if (pvpStats.pvpRankPointsNeeded != null && pvpStats.pvpRank < 80)
                  Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.white),
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      width: 128.0,
                      height: 8.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: LinearProgressIndicator(
                          value: pvpStats.pvpRankPoints / pvpStats.pvpRankPointsNeeded,
                          backgroundColor: Colors.white24
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 16.0,
                    children: <Widget>[
                      if (pvpStats.ladders != null && pvpStats.ladders.unranked != null
                        && pvpStats.ladders.unranked.wins + pvpStats.ladders.unranked.losses != 0)
                        _WinRateInfoBox(
                          header: 'Unranked\nwinrate',
                          winLoss: pvpStats.ladders.unranked,
                        ),
                      if (pvpStats.ladders != null && pvpStats.ladders.ranked != null
                        && pvpStats.ladders.ranked.wins + pvpStats.ladders.ranked.losses != 0)
                        _WinRateInfoBox(
                          header: 'Ranked\nwinrate',
                          winLoss: pvpStats.ladders.ranked,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Theme.of(context).accentColor,
              color: Theme.of(context).cardColor,
              onRefresh: () async {
                BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent());
                await Future.delayed(Duration(milliseconds: 200), () {});
              },
              child: CompanionListView(
                children: <Widget>[
                  CompanionButton(
                    color: Colors.orange,
                    title: 'Ranked seasons',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SeasonsPage()
                    )),
                    leading: Icon(
                      FontAwesomeIcons.trophy,
                      size: 35.0,
                      color: Colors.white,
                    ),
                  ),
                  CompanionButton(
                    color: Colors.blue,
                    title: 'Game history',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PvpGamesPage()
                    )),
                    leading: Icon(
                      FontAwesomeIcons.history,
                      size: 35.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _WinRateInfoBox extends StatelessWidget {
  final String header;
  final PvpWinLoss winLoss;

  _WinRateInfoBox({
    @required this.header,
    @required this.winLoss
  });

  @override
  Widget build(BuildContext context) {
    int total = winLoss.wins + winLoss.losses;

    return CompanionInfoBox(
      header: header,
      text: ((winLoss.wins / total) * 100).toStringAsFixed(2) + '%',
      loading: false,
    );
  }
}