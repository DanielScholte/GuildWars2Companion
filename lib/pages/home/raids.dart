import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/raid/raid_bloc.dart';
import 'package:guildwars2_companion/models/other/raid.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class RaidsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.blue),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Raids',
          color: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<RaidBloc, RaidState>(
          builder: (context, state) {
            if (state is ErrorRaidsState) {
              return Center(
                child: CompanionError(
                  title: 'the raids',
                  onTryAgain: () =>
                    BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(state.includeProgress)),
                ),
              );
            }

            if (state is LoadedRaidsState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Colors.white,
                onRefresh: () async {
                  BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(state.includeProgress));
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: ListView(
                  children: state.raids
                    .map((d) => _buildRaidRow(context, d))
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

  Widget _buildRaidRow(BuildContext context, Raid raid) {
    return CompanionFullButton(
      color: raid.color,
      title: raid.name,
      height: null,
      leading: Image.asset(
        'assets/raids/${raid.id}.jpg'
      ),
      subtitleWidgets: raid.checkpoints
        .map((c) => Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Row(
            children: <Widget>[
              if (c.completed)
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
                    c.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
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
    );
    // return CompanionFullButton(
    //   color: raid.color,
    //   title: raid.name,
    //   leading: Stack(
    //     children: <Widget>[
    //       Image.asset('assets/dungeons/${raid.id}.jpg'),
    //       if (raid.completed)
    //         Container(
    //           width: double.infinity,
    //           height: double.infinity,
    //           color: Colors.white60,
    //           alignment: Alignment.center,
    //           child: Icon(
    //             FontAwesomeIcons.check,
    //             color: Colors.black87,
    //             size: 38.0,
    //           ),
    //         ),
    //     ],
    //   ),
    //   subtitles: [
    //     raid.pathName,
    //   ],
    //   trailing: Padding(
    //     padding: EdgeInsets.symmetric(horizontal: 16.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.only(top: 2.0),
    //           child: CompanionCoin(raid.coin,
    //             color: Colors.white,
    //           ),
    //         ),
    //         Text(
    //           'Level ${raid.level}',
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: 16.0,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}