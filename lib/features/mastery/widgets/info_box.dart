import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/info_box.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';

class MasteryInfoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchievementBloc, AchievementState>(
      builder: (context, state) {
        if (state is LoadedAchievementsState) {

          if (state.masteryLevel == null) {
            return CompanionInfoBox(
              header: 'Mastery level',
              text: '-',
              loading: false,
            );
          }

          return CompanionInfoBox(
            header: 'Mastery level',
            text: GuildWarsUtil.intToString(state.masteryLevel),
            loading: false,
          );
        }

        if (state is ErrorAchievementsState) {
          return CompanionInfoBox(
            header: 'Mastery level',
            loading: false,
          );
        }

        return CompanionInfoBox(
          header: 'Mastery level',
        );
      },
    );
  }
}