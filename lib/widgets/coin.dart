import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:intl/intl.dart';

class CompanionCoin extends StatelessWidget {

  final int coin;

  CompanionCoin(this.coin);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: 
        _getCoin(coin)
        .map((c) => Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Row(
            children: <Widget>[
              Text(
                _valueToString(c.value),
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Container(
                width: 20.0,
                height: 20.0,
                margin: EdgeInsets.only(left: 4.0),
                child: Image.asset(c.icon)
              )
            ],
          ),
        ))
        .toList(),
    );
  }

  String _valueToString(int value) {
    return NumberFormat('###,###', 'en').format(value);
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
      if (silver > 0)
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