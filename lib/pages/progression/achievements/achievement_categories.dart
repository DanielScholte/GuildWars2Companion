import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/expandable_header.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

import 'achievements.dart';

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
                    .map((g) => _buildGroup(context, g))
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

  Widget _buildGroup(BuildContext context, AchievementGroup group) {
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
                GuildWarsUtil.masteryIcon(r),
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
              .map((c) => _buildCategoryButton(c, context))
              .toList()
          ),
        ),
      ),
    );
  }

  CompanionButton _buildCategoryButton(AchievementCategory category, BuildContext context) {
    return CompanionButton(
      title: category.name,
      height: 64.0,
      color: Colors.white,
      foregroundColor: Colors.black,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AchievementsPage(category)
      )),
      leading: _buildCategoryButtonLeading(category, context),
      trailing: Row(
        children: category.regions
          .map((r) => Image.asset(
            GuildWarsUtil.masteryIcon(r),
            height: 28.0,
            width: 28.0,
          ))
          .toList(),
      ),
    );
  }

  Widget _buildCategoryButtonLeading(AchievementCategory category, BuildContext context) {
    if (category.completedAchievements != null) {
      double ratio = category.completedAchievements / category.achievementsInfo.length;

      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CompanionCachedImage(
                height: 40.0,
                imageUrl: category.icon,
                color: Colors.black,
                iconSize: 28,
                fit: BoxFit.fill,
              ),
              Column(
                children: <Widget>[
                  Text(
                    '${(ratio * 100).round()}%',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      accentColor: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
                    ),
                    child: LinearProgressIndicator(
                      value: ratio,
                      backgroundColor: Colors.transparent,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      );
    }

    return CompanionCachedImage(
      height: 48.0,
      imageUrl: category.icon,
      color: Colors.black,
      iconSize: 28,
      fit: BoxFit.fill,
    );
  }
}
