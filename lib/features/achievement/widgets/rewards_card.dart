import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';
import 'package:guildwars2_companion/core/widgets/coin.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';

class AchievementRewardsCard extends StatelessWidget {
  final Achievement achievement;

  AchievementRewardsCard({@required this.achievement});

  @override
  Widget build(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Rewards',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Column(
            children: achievement.rewards
              .map((r) {
                switch (r.type) {
                  case 'Coins':
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CompanionCoin(r.count),
                        ),
                      ],
                    );
                    break;
                  case 'Item':
                    return Row(
                      children: <Widget>[
                        CompanionItemBox(
                          item: r.item,
                          hero: '${r.id} ${achievement.rewards.indexOf(r)}',
                          quantity: r.count,
                          size: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            r.item.name,
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    );
                    break;
                  case 'Mastery':
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            GuildWarsUtil.masteryIcon(r.region),
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            GuildWarsUtil.masteryName(r.region) + ' Mastery point',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    );
                  case 'Title':
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/images/progression/title.png',
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            r.title.name,
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    );
                }

                return Container();
              })
              .toList(),
          )
        ],
      ),
    );
  }
}