import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/pages/progression/achievement_categories.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class ProgressionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.orange),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Progression',
          color: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is LoadedAchievementsState) {
              return _buildButtonList();
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonList() {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return ListView(
            children: <Widget>[
              CompanionFullButton(
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
              CompanionFullButton(
                color: Colors.indigo,
                onTap: () {},
                title: 'Dailies',
                leading: Icon(
                  GuildWarsIcons.daily,
                  size: 42.0,
                  color: Colors.white,
                ),
              ),
              CompanionFullButton(
                color: Colors.red,
                onTap: () {},
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

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}