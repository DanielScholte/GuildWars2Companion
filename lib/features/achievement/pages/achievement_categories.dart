import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/expandable_header.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement_category.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement_group.dart';
import 'package:guildwars2_companion/features/achievement/widgets/achievement_category_button.dart';

class AchievementCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.orange,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Achievements',
          color: Colors.orange,
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
                  children: state.achievementGroups
                    .map((g) => _AchievementGroupCard(group: g))
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
}

class _AchievementGroupCard extends StatelessWidget {
  final AchievementGroup group;

  _AchievementGroupCard({@required this.group});

  @override
  Widget build(BuildContext context) {
    List<AchievementCategory> categories = group.categoriesInfo
      .where((c) => c.achievementsInfo.isNotEmpty)
      .toList();

    return CompanionCard(
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey : Colors.white30,
      child: CompanionExpandableHeader(
        header: group.name,
        foreground: Colors.white,
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: group.regions
              .map((r) => Image.asset(
                Assets.getMasteryAsset(r),
                height: 24.0,
                width: 24.0,
              ))
              .toList(),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Column(
            children: categories
              .map((c) => AchievementCategoryButton(category: c))
              .toList()
          ),
        ),
      ),
    );
  }
}