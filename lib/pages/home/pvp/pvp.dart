import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/pvp/pvp_bloc.dart';
import 'package:guildwars2_companion/models/pvp/stats.dart';
import 'package:guildwars2_companion/pages/home/pvp/games.dart';
import 'package:guildwars2_companion/pages/home/pvp/seasons.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_box.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class PvpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Color(0xFF678A9E),
      child: BlocBuilder<PvpBloc, PvpState>(
        builder: (context, state) {
          if (state is ErrorPvpState) {
            return _buildBasicPage(context, Center(
              child: CompanionError(
                title: 'PvP Statistics',
                onTryAgain: () =>
                  BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent()),
              ),
            ));
          }

          if (state is LoadedPvpState) {
            return _buildPvpPage(context, state);
          }

          return _buildBasicPage(context, Center(
            child: CircularProgressIndicator()
          ));
        },
      )
    );
  }

  Widget _buildBasicPage(BuildContext context, Widget child) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: '',
        color: Color(0xFF678A9E),
      ),
      body: child,
    );
  }

  Widget _buildPvpPage(BuildContext context, LoadedPvpState state) {
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
                      imageUrl: state.pvpStats.rank.icon,
                      color: Colors.white,
                      iconSize: 20,
                      fit: null,
                    ),
                  ),
                ),
                Text(
                  'Rank ${state.pvpStats.pvpRank}',
                  style: Theme.of(context).textTheme.headline1,
                ),
                if (state.pvpStats.pvpRankPointsNeeded != null && state.pvpStats.pvpRank < 80)
                  _buildProgress(context, state),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 16.0,
                    children: <Widget>[
                      if (state.pvpStats.ladders != null && state.pvpStats.ladders.unranked != null
                        && state.pvpStats.ladders.unranked.wins + state.pvpStats.ladders.unranked.losses != 0)
                        _buildWinrateBox(state.pvpStats.ladders.unranked, 'Unranked\nwinrate'),
                      if (state.pvpStats.ladders != null && state.pvpStats.ladders.ranked != null
                        && state.pvpStats.ladders.ranked.wins + state.pvpStats.ladders.ranked.losses != 0)
                        _buildWinrateBox(state.pvpStats.ladders.ranked, 'Ranked\nwinrate')
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

  Widget _buildWinrateBox(PvpWinLoss winLoss, String header) {
    int total = winLoss.wins + winLoss.losses;

    return CompanionInfoBox(
      header: header,
      text: ((winLoss.wins / total) * 100).toStringAsFixed(2) + '%',
      loading: false,
    );
  }

  Widget _buildProgress(BuildContext context, LoadedPvpState state) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.white),
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: 128.0,
        height: 8.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: state.pvpStats.pvpRankPoints / state.pvpStats.pvpRankPointsNeeded,
            backgroundColor: Colors.white24
          ),
        ),
      ),
    );
  }
}