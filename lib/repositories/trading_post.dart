import 'dart:convert';

import 'package:guildwars2_companion/models/trading_post/price.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:http/http.dart' as http;

class TradingPostRepository {
  Future<TradingPostPrice> getItemPrice(int itemId) async {
    final response = await http.get(
      Urls.tradingPostPriceUrl + itemId.toString(),
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      return TradingPostPrice.fromJson(json.decode(response.body));
    }

    throw Exception('Failed to load item price');
  }
}