import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/features/wallet/models/currency.dart';

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
                style: Theme.of(context).brightness == Brightness.light ? Theme.of(context).textTheme.bodyText1.copyWith(
                  color: color
                ) : Theme.of(context).textTheme.bodyText1,
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
          icon: Assets.coinGold
        ),
      if (silver > 0 || (gold > 0 && includeZero))
        Currency(
          name: 'Silver',
          value: silver,
          icon: Assets.coinSilver
        ),
      if (includeZero || copper > 0)
        Currency(
          name: 'Copper',
          value: copper,
          icon: Assets.coinCopper
        ),
    ];
  }
}