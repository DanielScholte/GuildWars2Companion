import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/raid/raid_bloc.dart';
import 'package:guildwars2_companion/models/other/raid.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/header.dart';

class RaidPage extends StatelessWidget {

  final Raid raid;

  RaidPage(this.raid);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: raid.color),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: _buildProgression(context)
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CompanionHeader(
      color: raid.color,
      wikiName: raid.name,
      includeBack: true,
      child: Column(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.asset('assets/raids_square/${raid.id}.jpg'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              raid.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgression(BuildContext context) {
    return BlocBuilder<RaidBloc, RaidState>(
      builder: (context, state) {
        if (state is ErrorRaidsState) {
          return Center(
            child: CompanionError(
              title: 'the raid',
              onTryAgain: () =>
                BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(state.includeProgress)),
            ),
          );
        }

        if (state is LoadedRaidsState) {
          Raid _raid = state.raids.firstWhere((r) => r.id == raid.id);

          if (_raid != null) {
            return RefreshIndicator(
              backgroundColor: Theme.of(context).accentColor,
              color: Colors.white,
              onRefresh: () async {
                BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(state.includeProgress));
                await Future.delayed(Duration(milliseconds: 200), () {});
              },
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: [
                  _buildProgress(state.includeProgress, _raid)
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

  Widget _buildProgress(bool includeProgress, Raid _raid) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              includeProgress ? 'Weekly Progress' : 'Bosses',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Column(
            children: _raid.checkpoints
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
                        style: TextStyle(
                          fontSize: 16.0
                        ),
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