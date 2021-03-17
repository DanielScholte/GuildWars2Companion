import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/features/dungeon/bloc/dungeon_bloc.dart';
import 'package:guildwars2_companion/features/dungeon/models/dungeon.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/features/dungeon/widgets/progress_card.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';

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
            _Header(dungeon: dungeon),
            Expanded(
              child: BlocBuilder<DungeonBloc, DungeonState>(
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
                            DungeonProgressCard(
                              dungeon: _dungeon,
                              includeProgress: state.includeProgress,
                            )
                          ],
                        ),
                      );
                    }
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Dungeon dungeon;

  _Header({@required this.dungeon});

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset('assets/images/dungeons_square/${dungeon.id}.jpg'),
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
}