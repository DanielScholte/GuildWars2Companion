import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/info_box.dart';
import 'package:guildwars2_companion/features/account/models/account.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';

class AchievementInfoBox extends StatelessWidget {
  // To get the daily and monthy achievement points
  final Account account;

  AchievementInfoBox({@required this.account});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchievementBloc, AchievementState>(
      builder: (context, state) {
        if (state is LoadedAchievementsState) {
          return CompanionInfoBox(
            header: 'Achievements',
            text: GuildWarsUtil.intToString(state.achievementPoints + account.dailyAp + account.monthlyAp),
            loading: false,
          );
        }

        if (state is ErrorAchievementsState) {
          return CompanionInfoBox(
            header: 'Achievements',
            loading: false,
          );
        }

        return CompanionInfoBox(
          header: 'Achievements',
        );
      },
    );
  }
}