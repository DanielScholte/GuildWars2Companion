import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

import 'mastery_level.dart';

class MasteryLevelsPage extends StatelessWidget {

  final Mastery mastery;

  MasteryLevelsPage(this.mastery);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: GuildWarsUtil.regionColor(mastery.region),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: mastery.name,
          color: GuildWarsUtil.regionColor(mastery.region),
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is ErrorAchievementsState) {
              return Center(
                child: CompanionError(
                  title: 'the masteries',
                  onTryAgain: () =>
                    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                      includeProgress: state.includesProgress
                    )),
                ),
              );
            }

            if (state is LoadedAchievementsState) {
              Mastery _mastery = state.masteries.firstWhere((m) => m.id == mastery.id, orElse: () => null);
              
              if (_mastery != null) {
                return RefreshIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                  color: Theme.of(context).cardColor,
                  onRefresh: () async {
                    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                      includeProgress: state.includesProgress
                    ));
                    await Future.delayed(Duration(milliseconds: 200), () {});
                  },
                  child: CompanionListView(
                    children: _mastery.levels
                      .map((l) => CompanionButton(
                        title: l.name,
                        height: 64.0,
                        color: GuildWarsUtil.regionColor(_mastery.region),
                        hero: l.name,
                        leading: Stack(
                          children: <Widget>[
                            CompanionCachedImage(
                              imageUrl: l.icon,
                              color: Colors.white,
                              iconSize: 28,
                              fit: BoxFit.fill,
                            ),
                            if (l.done)
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white60,
                                alignment: Alignment.center,
                                child: Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.black87,
                                  size: 28.0,
                                ),
                              ),
                          ],
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                l.pointCost.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  GuildWarsIcons.mastery,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MasteryLevelPage(_mastery, l)
                        )),
                      ))
                      .toList()
                  ),
                );
              }

              if (state is ErrorAchievementsState) {
                return Center(
                  child: CompanionError(
                    title: 'the masteries',
                    onTryAgain: () =>
                      BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                        includeProgress: state.includesProgress
                      )),
                  ),
                );
              }
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
