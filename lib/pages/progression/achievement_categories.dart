import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
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
                  .map((g) => _buildGroup(g))
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

  Widget _buildGroup(AchievementGroup group) {
    return CompanionCard(
      padding: EdgeInsets.zero,
      child: CompanionExpandableHeader(
        header: group.name,
        child: Column(
          children: group.categoriesInfo
            .where((c) => c.achievementsInfo.isNotEmpty)
            .map((c) => CompanionFullButton(
              title: c.name,
              height: 64.0,
              color: Colors.blue,
              onTap: () {},
              leading: CachedNetworkImage(
                height: 64.0,
                imageUrl: c.icon,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Icon(
                  FontAwesomeIcons.dizzy,
                  size: 28,
                  color: Colors.black,
                )),
                fit: BoxFit.fill,
              ),
            ))
            .toList()
        ),
      ),
    );
  }
}