import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/pages/progression/achievements.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/expandable_header.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class AchievementCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.orange),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Achievements',
          color: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is LoadedAchievementsState) {
              return ListView(
                children: state.achievementGroups
                  .map((g) => _buildGroup(context, g))
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

  Widget _buildGroup(BuildContext context, AchievementGroup group) {
    List<AchievementCategory> categories = group.categoriesInfo
      .where((c) => c.achievementsInfo.isNotEmpty)
      .toList();
    return CompanionCard(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.blueGrey,
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
        child: Column(
          children: categories
            .map((c) => CompanionFullButton(
              title: c.name,
              height: 64.0,
              color: Colors.white,
              foregroundColor: Colors.black,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AchievementsPage(c)
              )),
              leading: CachedNetworkImage(
                height: 48.0,
                imageUrl: c.icon,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Icon(
                  FontAwesomeIcons.dizzy,
                  size: 28,
                  color: Colors.black,
                )),
                fit: BoxFit.fill,
              ),
              trailing: Row(
                children: c.regions
                  .map((r) => Image.asset(
                    GuildWarsUtil.masteryIcon(r),
                    height: 28.0,
                    width: 28.0,
                  ))
                  .toList(),
              ),
            ))
            .toList()
        ),
      ),
    );
  }
}