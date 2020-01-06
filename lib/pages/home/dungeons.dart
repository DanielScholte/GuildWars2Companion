import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/dungeons/bloc.dart';
import 'package:guildwars2_companion/models/other/dungeon.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/coin.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class DungeonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.deepOrange),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Dungeons',
          color: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<DungeonBloc, DungeonState>(
            builder: (context, state) {
              if (state is LoadedDungeonsState) {

                return ListView(
                  children: state.dungeons
                    .map((d) => _buildDungeonRow(context, d))
                    .toList(),
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
    return CompanionFullButton(
      color: dungeon.color,
      title: dungeon.name,
      leading: Stack(
        children: <Widget>[
          Image.asset('assets/dungeons/${dungeon.id}.jpg'),
          if (dungeon.completed)
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
        dungeon.pathName,
      ],
      trailing: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: CompanionCoin(dungeon.coin,
                color: Colors.white,
              ),
            ),
            Text(
              'Level ${dungeon.level}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}