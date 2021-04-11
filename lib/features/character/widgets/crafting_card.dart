import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/features/character/models/crafting.dart';

class CharacterCraftingCard extends StatelessWidget {
  final List<Crafting> craftingList;

  CharacterCraftingCard({@required this.craftingList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
      child: Column(
        children: <Widget>[
          Text(
            'Crafting disciplines',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: craftingList
              .where((c) => GuildWarsUtil.validDisciplines().contains(c.discipline))
              .map((c) => Padding(
                padding: EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(Assets.getCraftingDisciplineAsset(c.discipline)),
                    Text(
                      c.rating.toString(),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ))
              .toList(),
          ),
        ],
      ),
    );
  }
}