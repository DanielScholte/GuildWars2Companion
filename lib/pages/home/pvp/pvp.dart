import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/pvp/pvp_bloc.dart';
import 'package:guildwars2_companion/models/pvp/rank.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/header.dart';

class PvpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.blueGrey),
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
        color: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: child,
    );
  }

  Widget _buildPvpPage(BuildContext context, LoadedPvpState state) {
    PvpRankLevels level = state.pvpStats.rank.levels
      .firstWhere((l) => l.minRank <= state.pvpStats.pvpRank && l.maxRank >= state.pvpStats.pvpRank, orElse: () => null);

    return Scaffold(
      body: Column(
        children: <Widget>[
          CompanionHeader(
            color: Colors.blueGrey,
            includeBack: true,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 48.0,
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: CachedNetworkImage(
                      height: 96.0,
                      imageUrl: state.pvpStats.rank.icon,
                      placeholder: (context, url) => Theme(
                        data: Theme.of(context).copyWith(accentColor: Colors.white),
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(child: Icon(
                        FontAwesomeIcons.dizzy,
                        size: 20,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),
                Text(
                  'Rank ${state.pvpStats.pvpRank}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                if (level != null && state.pvpStats.pvpRankPoints < level.points)
                  _buildProgress(context, level, state),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Theme.of(context).accentColor,
              color: Colors.white,
              onRefresh: () async {
                BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent());
                await Future.delayed(Duration(milliseconds: 200), () {});
              },
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: <Widget>[

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgress(BuildContext context, PvpRankLevels level, LoadedPvpState state) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.white),
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: 128.0,
        height: 8.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: state.pvpStats.pvpRankPoints / level.points,
            backgroundColor: Colors.white24
          ),
        ),
      ),
    );
  }
}