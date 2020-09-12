import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/dungeon/bloc.dart';
import 'package:guildwars2_companion/models/other/dungeon.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

import 'dungeon.dart';

class DungeonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.deepOrange,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Dungeons',
          color: Colors.deepOrange,
        ),
        body: BlocBuilder<DungeonBloc, DungeonState>(
          builder: (context, state) {
            if (state is ErrorDungeonsState) {
              return Center(
                child: CompanionError(
                  title: 'the dungeons',
                  onTryAgain: () =>
                    BlocProvider.of<DungeonBloc>(context).add(LoadDungeonsEvent(state.includeProgress)),
                ),
              );
            }

            if (state is LoadedDungeonsState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<DungeonBloc>(context).add(LoadDungeonsEvent(state.includeProgress));
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: state.dungeons
                    .map((d) => _buildDungeonRow(context, d))
                    .toList(),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDungeonRow(BuildContext context, Dungeon dungeon) {
    return CompanionButton(
      color: dungeon.color,
      title: dungeon.name,
      height: null,
      hero: dungeon.id,
      leading: Image.asset(
        'assets/dungeons/${dungeon.id}.jpg'
      ),
      subtitleWidgets: dungeon.paths
        .map((p) => Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Row(
            children: <Widget>[
              if (p.completed)
                Icon(
                  FontAwesomeIcons.check,
                  color: Colors.white,
                  size: 20.0,
                )
              else
                Container(
                  width: 20.0,
                  child: Icon(
                    FontAwesomeIcons.solidCircle,
                    color: Colors.white,
                    size: 6.0,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    p.name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ))
        .toList(),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DungeonPage(dungeon)
      )),
    );
  }
}
