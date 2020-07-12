import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/dungeon/bloc.dart';
import 'package:guildwars2_companion/models/other/dungeon.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/listview.dart';

class DungeonPage extends StatelessWidget {

  final Dungeon dungeon;

  DungeonPage(this.dungeon);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: dungeon.color,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: _buildProgression(context)
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CompanionHeader(
      color: dungeon.color,
      wikiName: dungeon.name,
      wikiRequiresEnglish: true,
      includeBack: true,
      child: Column(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                if (Theme.of(context).brightness == Brightness.light)
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                  ),
              ],
            ),
            child: Hero(
              tag: dungeon.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset('assets/dungeons_square/${dungeon.id}.jpg'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              dungeon.name,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            dungeon.location,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgression(BuildContext context) {
    return BlocBuilder<DungeonBloc, DungeonState>(
      builder: (context, state) {
        if (state is ErrorDungeonsState) {
          return Center(
            child: CompanionError(
              title: 'the dungeon',
              onTryAgain: () =>
                BlocProvider.of<DungeonBloc>(context).add(LoadDungeonsEvent(state.includeProgress)),
            ),
          );
        }

        if (state is LoadedDungeonsState) {
          Dungeon _dungeon = state.dungeons.firstWhere((d) => d.id == dungeon.id);

          if (_dungeon != null) {
            return RefreshIndicator(
              backgroundColor: Theme.of(context).accentColor,
              color: Theme.of(context).cardColor,
              onRefresh: () async {
                BlocProvider.of<DungeonBloc>(context).add(LoadDungeonsEvent(state.includeProgress));
                await Future.delayed(Duration(milliseconds: 200), () {});
              },
              child: CompanionListView(
                children: [
                  _buildProgress(context, state.includeProgress, _dungeon)
                ],
              ),
            );
          }
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildProgress(BuildContext context, bool includeProgress, Dungeon _dungeon) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              includeProgress ? 'Daily Progress' : 'Paths',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Column(
            children: _dungeon.paths
              .map((p) => Row(
                children: <Widget>[
                  if (p.completed)
                    Icon(
                      FontAwesomeIcons.check,
                      size: 20.0,
                    )
                  else
                    Container(
                      width: 20.0,
                      child: Icon(
                        FontAwesomeIcons.solidCircle,
                        size: 6.0,
                      ),
                    ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        p.name,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ))
              .toList(),
            ),
        ],
      ),
    );
  }
}