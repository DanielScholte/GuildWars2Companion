import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class MasteryLevelsPage extends StatelessWidget {

  final Mastery mastery;

  MasteryLevelsPage(this.mastery);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: GuildWarsUtil.regionColor(mastery.region)),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: mastery.name,
          color: GuildWarsUtil.regionColor(mastery.region),
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is LoadedAchievementsState) {
              return ListView(
                children: []
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