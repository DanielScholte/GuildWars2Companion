import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/achievement/achievement_state.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/pages/progression/achievements/achievement.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/coin.dart';

import 'button.dart';
import 'cached_image.dart';

class CompanionAchievementButton extends StatelessWidget {
  final LoadedAchievementsState state;
  final Achievement achievement;
  final String categoryIcon;
  final String levels;
  final String hero;

  CompanionAchievementButton({
    @required this.state,
    @required this.achievement,
    this.categoryIcon,
    this.levels,
    this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      title: achievement.name,
      height: 64.0,
      color: Colors.blueGrey,
      onTap: () {
        if (!achievement.loaded && !achievement.loading) {
          BlocProvider.of<AchievementBloc>(context).add(LoadAchievementDetailsEvent(
            achievementGroups: state.achievementGroups,
            achievements: state.achievements,
            masteries: state.masteries,
            dialies: state.dailies,
            dialiesTomorrow: state.dailiesTomorrow,
            includeProgress: state.includesProgress,
            achievementPoints: state.achievementPoints,
            masteryLevel: state.masteryLevel,
            achievementId: achievement.id,
          ));
        }

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AchievementPage(
            achievement: achievement,
            categoryIcon: categoryIcon,
            hero: hero != null ? hero : achievement.id.toString(),
          )
        ));
      },
      leading: _buildLeading(context),
      trailing: _buildTrailing(),
      subtitles: this.levels != null ? [
        this.levels
      ] : null,
    );
  }

  Widget _buildTrailing() {
    int points = 0;
    achievement.tiers.forEach((t) => points += t.points);

    if (achievement.pointCap != null) {
      points = achievement.pointCap;
    }

    int coin = 0;
    bool item = false;
    String region;
    bool title = false;

    if (achievement.rewards != null) {
      achievement.rewards.forEach((reward) {
        switch(reward.type) {
          case 'Coins':
            coin = reward.count;
            return;
          case 'Item':
            item = true;
            return;
          case 'Mastery':
            region = reward.region;
            return;
          case 'Title':
            title = true;
            return;
        }
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (points > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                points.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0
                ),
              ),
              Container(width: 4.0,),
              Image.asset(
                'assets/progression/ap.png',
                height: 16.0,
              )
            ],
          ),
        if (item || title || region != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (region != null)
                Image.asset(
                  GuildWarsUtil.masteryIcon(region),
                  height: 16.0,
                  width: 16.0,
                ),
              if (item)
                Padding(
                  padding: region != null ? EdgeInsets.only(left: 4.0) : EdgeInsets.zero,
                  child: Image.asset(
                    'assets/progression/chest.png',
                    height: 16.0,
                    width: 16.0,
                  ),
                ),
              if (title)
                Padding(
                  padding: region != null || item ? EdgeInsets.only(left: 4.0) : EdgeInsets.zero,
                  child: Image.asset(
                    'assets/progression/title.png',
                    width: 16.0,
                    height: 16.0,
                  ),
                )
            ],
          ),
        if (coin > 0)
          CompanionCoin(
            coin,
            color: Colors.white,
            includeZero: false,
          ),
      ],
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (!state.includesProgress) {
      return _buildIcon();
    }

    int points = 0;
    achievement.tiers.forEach((t) => points += t.points);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: 
            achievement.progress != null && !achievement.progress.done
            ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (achievement.progress != null && achievement.progress.unlocked != null && !achievement.progress.unlocked)
              Icon(
                FontAwesomeIcons.lock,
                color: Colors.black87,
                size: 28.0,
              )
            else
              _buildIcon(height: 40.0),
            if (achievement.progress != null && achievement.progress.current != null && achievement.progress.max != null)
              Column(
                children: <Widget>[
                  Text(
                    '${((achievement.progress.current / achievement.progress.max) * 100).round()}%',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.white),
                    child: LinearProgressIndicator(
                      value: achievement.progress.current / achievement.progress.max,
                      backgroundColor: Colors.transparent,
                    ),
                  )
                ],
              )
          ],
        ),
        if (achievement.progress != null && achievement.progress.done || (
          achievement.pointCap != null && achievement.progress != null &&
          achievement.progress.repeated != null && achievement.progress.repeated * points >= achievement.pointCap
        ))
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white60,
            alignment: Alignment.center,
            child: Icon(
              FontAwesomeIcons.check,
              color: Colors.black87,
              size: 28.0,
            ),
          ),
      ],
    );
  }

  Widget _buildIcon({height = 48.0}) {
    if (achievement.icon == null && categoryIcon != null && categoryIcon.contains('assets')) {
      return Hero(
        tag: hero != null ? hero : achievement.id.toString(),
        child: Image.asset(categoryIcon, height: height,),
      );
    }

    if (achievement.icon != null || categoryIcon != null) {
      return Hero(
        tag: hero != null ? hero : achievement.id.toString(),
        child: CompanionCachedImage(
          height: height,
          imageUrl: achievement.icon != null ? achievement.icon : categoryIcon,
          color: Colors.white,
          iconSize: 28,
          fit: BoxFit.fill,
        ),
      );
    }

    return Container();
  }
}
