import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';

class CompanionCoin extends StatelessWidget {

  final int coin;
  final double innerPadding;

  CompanionCoin(this.coin, {
    this.innerPadding = 4.0
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: 
        _getCoin(coin)
        .map((c) => Padding(
          padding: EdgeInsets.only(left: innerPadding),
          child: Row(
            children: <Widget>[
              Text(
                GuildWarsUtil.intToString(c.value),
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Container(
                width: 16.0,
                height: 16.0,
                margin: EdgeInsets.only(left: innerPadding),
                child: Image.asset(c.icon)
              )
            ],
          ),
        ))
        .toList(),
    );
  }

  List<Currency> _getCoin(int coin) {
    int gold = coin ~/ 10000;
    int silver = (coin - (gold * 10000)) ~/ 100;
    int copper = (coin - (gold * 10000) - (silver * 100));

    return [
      if (gold > 0)
        Currency(
          name: 'Gold',
          value: gold,
          icon: 'assets/coin/gold_coin.png'
        ),
      if (silver > 0 || gold > 0)
        Currency(
          name: 'Silver',
          value: silver,
          icon: 'assets/coin/silver_coin.png'
        ),
      Currency(
        name: 'Copper',
        value: copper,
        icon: 'assets/coin/copper_coin.png'
      ),
    ];
  }
}