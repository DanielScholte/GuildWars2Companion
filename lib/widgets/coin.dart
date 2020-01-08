import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';

class CompanionCoin extends StatelessWidget {

  final int coin;
  final double innerPadding;
  final Color color;
  final bool includeZero;

  CompanionCoin(this.coin, {
    this.innerPadding = 4.0,
    this.color = Colors.black,
    this.includeZero = true,
  });

  @override
  Widget build(BuildContext context) {
    List<Currency> _currency = _getCoin(coin);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: 
        _currency
        .map((c) => Padding(
          padding: _currency.indexOf(c) > 0 ? EdgeInsets.only(left: innerPadding) : EdgeInsets.zero,
          child: Row(
            children: <Widget>[
              Text(
                GuildWarsUtil.intToString(c.value),
                style: TextStyle(
                  fontSize: 16.0,
                  color: color
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
      if (silver > 0 || (gold > 0 && includeZero))
        Currency(
          name: 'Silver',
          value: silver,
          icon: 'assets/coin/silver_coin.png'
        ),
      if (includeZero || copper > 0)
        Currency(
          name: 'Copper',
          value: copper,
          icon: 'assets/coin/copper_coin.png'
        ),
    ];
  }
}