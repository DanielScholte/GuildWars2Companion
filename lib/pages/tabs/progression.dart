import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/pages/progression/achievements/achievement_categories.dart';
import 'package:guildwars2_companion/pages/progression/achievements/favorite_achievements.dart';
import 'package:guildwars2_companion/pages/progression/dailies/daily_categories.dart';
import 'package:guildwars2_companion/pages/progression/masteries/masteries.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class ProgressionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.orange,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Progression',
          color: Colors.orange,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is ErrorAchievementsState) {
              return Center(
                child: CompanionError(
                  title: 'the progression',
                  onTryAgain: () =>
                    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                      includeProgress: state.includesProgress
                    )),
                ),
              );
            }

            if (state is LoadedAchievementsState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                    includeProgress: state.includesProgress
                  ));
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: _buildButtonList(context),
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

  Widget _buildButtonList(BuildContext context) {
    return CompanionListView(
      children: <Widget>[
        CompanionButton(
          color: Colors.orange,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AchievementCategoriesPage()
          )),
          title: 'Achievements',
          leading: Icon(
            GuildWarsIcons.achievement,
            size: 42.0,
            color: Colors.white,
          ),
        ),
        CompanionButton(
          color: Colors.blue,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FavoriteAchievementsPage()
          )),
          title: 'Favorite achievements',
          leading: Icon(
            Icons.star,
            size: 42.0,
            color: Colors.white,
          ),
        ),
        CompanionButton(
          color: Colors.indigo,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DailyCategoriesPage()
          )),
          title: 'Dailies',
          leading: Icon(
            GuildWarsIcons.daily,
            size: 42.0,
            color: Colors.white,
          ),
        ),
        CompanionButton(
          color: Colors.red,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MasteriesPage()
          )),
          title: 'Masteries',
          leading: Icon(
            GuildWarsIcons.mastery,
            size: 42.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
