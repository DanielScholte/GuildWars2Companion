import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

import 'mastery_level.dart';

class MasteryLevelsPage extends StatelessWidget {

  final Mastery mastery;

  MasteryLevelsPage(this.mastery);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: GuildWarsUtil.regionColor(mastery.region)),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: mastery.name,
          color: GuildWarsUtil.regionColor(mastery.region),
          foregroundColor: Colors.white,
          elevation: 4.0,
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
                  color: Colors.white,
                  onRefresh: () async {
                    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                      includeProgress: state.includesProgress
                    ));
                    await Future.delayed(Duration(milliseconds: 200), () {});
                  },
                  child: ListView(
                    children: _mastery.levels
                      .map((l) => CompanionFullButton(
                        title: l.name,
                        height: 64.0,
                        color: GuildWarsUtil.regionColor(_mastery.region),
                        leading: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: l.icon,
                              placeholder: (context, url) => Center(child: Theme(
                                data: Theme.of(context).copyWith(accentColor: Colors.white),
                                child: CircularProgressIndicator()
                              )),
                              errorWidget: (context, url, error) => Center(child: Icon(
                                FontAwesomeIcons.dizzy,
                                size: 28,
                                color: Colors.white,
                              )),
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