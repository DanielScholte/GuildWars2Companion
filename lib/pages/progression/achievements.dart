import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/widgets/achievement_button.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class AchievementsPage extends StatelessWidget {

  final AchievementCategory achievementCategory;

  AchievementsPage(this.achievementCategory);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.blueGrey),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: achievementCategory.name,
          color: Colors.blueGrey,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is LoadedAchievementsState) {
              AchievementCategory _achievementCategory = _getAchievementsCategory(state);
              
              return ListView(
                children: _achievementCategory.achievementsInfo
                  .map((a) => CompanionAchievementButton(
                    state: state,
                    achievement: a,
                    categoryIcon: _achievementCategory.icon,
                  ))
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