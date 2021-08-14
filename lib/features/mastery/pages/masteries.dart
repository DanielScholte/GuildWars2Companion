import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/mastery/models/mastery.dart';

import 'mastery_levels.dart';

class MasteriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Masteries',
        color: Colors.red,
      ),
      body: BlocBuilder<AchievementBloc, AchievementState>(
        builder: (context, state) {
          if (state is ErrorAchievementsState) {
            return Center(
              child: CompanionError(
                title: 'the masteries',
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
                children: state.masteries
                  .map((mastery) => _MasteryButton(mastery: mastery))
                  .toList(),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _MasteryButton extends StatelessWidget {
  final Mastery mastery;

  _MasteryButton({@required  this.mastery});

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      title: mastery.name,
      color: GuildWarsUtil.regionColor(mastery.region),
      height: 64.0,
      leading: mastery.level != null && mastery.levels != null && mastery.levels.isNotEmpty ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Theme.of(context).brightness == Brightness.light ? Icon(
              GuildWarsIcons.mastery,
              size: 32.0,
              color: Colors.white,
            ) : Image.asset(
              Assets.getMasteryAsset(mastery.region),
              height: 32.0,
            )
          ),
          Column(
            children: <Widget>[
              Text(
                '${mastery.level} / ${mastery.levels.length}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              LinearProgressIndicator(
                value: (mastery.level) / mastery.levels.length,
                color: Colors.white,
                backgroundColor: Colors.transparent,
              )
            ],
          )
        ],
      ) : (Theme.of(context).brightness == Brightness.light ? Icon(
          GuildWarsIcons.mastery,
          size: 32.0,
          color: Colors.white,
        ) : Image.asset(
          Assets.getMasteryAsset(mastery.region),
          height: 32.0,
        )
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MasteryLevelsPage(mastery),
      )),
    );
  }
}
