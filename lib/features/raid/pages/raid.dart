import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/info_card.dart';
import 'package:guildwars2_companion/features/raid/bloc/raid_bloc.dart';
import 'package:guildwars2_companion/features/raid/models/raid.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';

class RaidPage extends StatelessWidget {

  final Raid raid;

  RaidPage(this.raid);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: raid.color,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CompanionHeader(
              color: raid.color,
              wikiName: raid.name,
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
                      tag: raid.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Image.asset(Assets.getRaidAsset(raid.id)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      raid.name,
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<RaidBloc, RaidState>(
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
                        color: Theme.of(context).cardColor,
                        onRefresh: () async {
                          BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(state.includeProgress));
                          await Future.delayed(Duration(milliseconds: 200), () {});
                        },
                        child: CompanionListView(
                          children: [
                            _ProgressCard(
                              raid: _raid,
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

class _ProgressCard extends StatelessWidget {
  final Raid raid;
  final bool includeProgress;

  _ProgressCard({
    @required this.raid,
    @required this.includeProgress
  });

  @override
  Widget build(BuildContext context) {
    return CompanionInfoCard(
      title: includeProgress ? 'Weekly Progress' : 'Bosses',
      child: Column(
        children: raid.checkpoints
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
    );
  }
}