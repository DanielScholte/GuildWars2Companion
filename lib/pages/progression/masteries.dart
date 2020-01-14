import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/pages/progression/mastery_levels.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class MasteriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.red),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Masteries',
          color: Colors.red,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (context, state) {
            if (state is LoadedAchievementsState) {
              return ListView(
                children: state.masteries
                  .map((g) => _buildMastery(context, g))
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

  Widget _buildMastery(BuildContext context, Mastery mastery) {
    return CompanionFullButton(
      title: mastery.name,
      color: GuildWarsUtil.regionColor(mastery.region),
      height: 64.0,
      leading: mastery.level != null && mastery.levels != null && mastery.levels.isNotEmpty ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(
              GuildWarsIcons.mastery,
              size: 32.0,
              color: Colors.white,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                '${mastery.level + 1} / ${mastery.levels.length}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: LinearProgressIndicator(
                  value: (mastery.level + 1) / mastery.levels.length,
                  backgroundColor: Colors.transparent,
                ),
              )
            ],
          )
        ],
      ) : Icon(
        GuildWarsIcons.mastery,
        size: 32.0,
        color: Colors.white,
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MasteryLevelsPage(mastery),
      )),
    );
  }
}