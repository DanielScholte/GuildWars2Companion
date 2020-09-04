import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/achievement_button.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class AchievementsPage extends StatelessWidget {

  final AchievementCategory achievementCategory;

  AchievementsPage(this.achievementCategory);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blueGrey,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: achievementCategory.name,
          color: Colors.blueGrey,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is ErrorAchievementsState) {
              return Center(
                child: CompanionError(
                  title: 'the achievements',
                  onTryAgain: () =>
                    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
                      includeProgress: state.includesProgress
                    )),
                ),
              );
            }

            if (state is LoadedAchievementsState) {
              AchievementCategory _achievementCategory = _getAchievementsCategory(state);

              if (_achievementCategory != null) {
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
                    children: _achievementCategory.achievementsInfo
                      .map((a) => CompanionAchievementButton(
                        state: state,
                        achievement: a,
                        categoryIcon: _achievementCategory.icon,
                      ))
                      .toList(),
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

  AchievementCategory _getAchievementsCategory(LoadedAchievementsState state) {
    AchievementCategory category;

    state.achievementGroups.forEach((group) {
      if (category == null) {
        category = group.categoriesInfo.firstWhere((t) => t.id == achievementCategory.id, orElse: () => null);
      }
    });

    return category;
  }
}