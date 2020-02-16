import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/pvp/pvp_bloc.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:intl/intl.dart';

class PvpGamesPage extends StatelessWidget {

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.blue),
      child: Scaffold(
        appBar: CompanionAppBar(
          color: Colors.blue,
          foregroundColor: Colors.white,
          title: 'Game history',
          elevation: 4.0,
        ),
        body: BlocBuilder<PvpBloc, PvpState>(
          builder: (context, state) {
            if (state is ErrorPvpState) {
              return Center(
                child: CompanionError(
                  title: 'game history',
                  onTryAgain: () =>
                    BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent()),
                ),
              );
            }

            if (state is LoadedPvpState && state.pvpGames.isEmpty) {
              return Center(
                child: Text(
                  'No pvp games found',
                  style: Theme.of(context).textTheme.display2.copyWith(
                    color: Colors.black
                  )
                ),
              );
            }

            if (state is LoadedPvpState) {
              return ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: state.pvpGames
                  .map((g) => CompanionCard(
                    child: ConstrainedBox(
                      constraints: new BoxConstraints(
                          minHeight: 42.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  g.map.name,
                                  style: Theme.of(context).textTheme.display2.copyWith(
                                    color: Colors.black
                                  ),
                                ),
                                Text(
                                  _dateFormat.format(DateTime.parse(g.started)),
                                  style: Theme.of(context).textTheme.display3.copyWith(
                                    color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                g.result,
                                style: Theme.of(context).textTheme.display3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: _getGameResultColor(g.result)
                                ),
                              ),
                              Text(
                                g.ratingType,
                                style: Theme.of(context).textTheme.display3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                                ),
                              ),
                            ],
                          ),
                          Container(width: 8.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                g.scores.blue.toString(),
                                style: Theme.of(context).textTheme.display3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue
                                ),
                              ),
                              Text(
                                g.scores.red.toString(),
                                style: Theme.of(context).textTheme.display3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
                  .toList(),
              );
            }

            return Center(
              child: CircularProgressIndicator()
            );
          },
        ),
      ),
    );
  }

  Color _getGameResultColor(String result) {
    switch (result) {
      case 'Victory':
        return Colors.green;
      case 'Defeat':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}