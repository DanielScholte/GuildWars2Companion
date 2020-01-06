import 'dart:convert';

import 'package:guildwars2_companion/models/trading_post/delivery.dart';
import 'package:guildwars2_companion/models/trading_post/listing.dart';
import 'package:guildwars2_companion/models/trading_post/price.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';
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

  Future<TradingPostDelivery> getDelivery() async {
    final response = await http.get(
      Urls.tradingPostDeliveryUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      return TradingPostDelivery.fromJson(json.decode(response.body));
    }

    return TradingPostDelivery(
      coins: 0,
      items: []
    );
  }

  Future<List<TradingPostTransaction>> getTransactions(String time, String type) async {
    final response = await http.get(
      '${Urls.tradingPostTransactionsUrl}$time/$type',
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List transactions = json.decode(response.body);
      return transactions.map((a) => TradingPostTransaction.fromJson(a)).toList();
    }

    return [];
  }

  Future<TradingPostListing> getListing(int itemId) async {
    final response = await http.get(
      Urls.tradingPostListingsUrl + itemId.toString(),
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200 || response.statusCode == 206) {
      return TradingPostListing.fromJson(json.decode(response.body));
    }

    return null;
  }
}