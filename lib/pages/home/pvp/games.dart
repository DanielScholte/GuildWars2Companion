import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/pvp/pvp_bloc.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';
import 'package:intl/intl.dart';

class PvpGamesPage extends StatelessWidget {

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          color: Colors.blue,
          title: 'Game history',
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
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            }

            if (state is LoadedPvpState) {
              return CompanionListView(
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
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                Text(
                                  _dateFormat.format(DateTime.parse(g.started)),
                                  style: Theme.of(context).textTheme.bodyText1,
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
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: _getGameResultColor(g.result)
                                ),
                              ),
                              Text(
                                g.ratingType,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.w500,
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
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue
                                ),
                              ),
                              Text(
                                g.scores.red.toString(),
                                style: Theme.of(context).textTheme.bodyText1.copyWith(
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