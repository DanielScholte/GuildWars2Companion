import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/widgets/coin.dart';

import 'full_button.dart';

class CompanionAchievementButton extends StatelessWidget {
  final Achievement achievement;
  final String categoryIcon;
  final bool includeProgress;

  CompanionAchievementButton({
    @required this.achievement,
    this.includeProgress = false,
    this.categoryIcon
  });

  @override
  Widget build(BuildContext context) {
    return CompanionFullButton(
      title: achievement.name,
      height: 64.0,
      color: Colors.blueGrey,
      onTap: () {},
      leading: _buildLeading(context),
      trailing: _buildTrailing(),
    );
  }

  Widget _buildTrailing() {
    achievement.tiers.sort((a, b) => a.points.compareTo(b.points));
    int points = achievement.tiers.last.points;

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
                  'assets/progression/mastery_${region.toLowerCase()}.png',
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
    if (!includeProgress) {
      return _buildIcon();
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: 
            achievement.progress != null && !achievement.progress.done
            ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CachedNetworkImage(
              height: 42.0,
              imageUrl: achievement.icon != null ? achievement.icon : categoryIcon,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(child: Icon(
                FontAwesomeIcons.dizzy,
                size: 28,
                color: Colors.black,
              )),
              fit: BoxFit.fill,
            ),
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
        if (achievement.progress != null && achievement.progress.done)
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

  Widget _buildIcon() {
    if (achievement.icon != null || categoryIcon != null) {
      return CachedNetworkImage(
        height: 48.0,
        imageUrl: achievement.icon != null ? achievement.icon : categoryIcon,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Center(child: Icon(
          FontAwesomeIcons.dizzy,
          size: 28,
          color: Colors.black,
        )),
        fit: BoxFit.fill,
      );
    }

    return Container();
  }
}