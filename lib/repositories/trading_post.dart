import 'package:dio/dio.dart';
import 'package:guildwars2_companion/models/trading_post/delivery.dart';
import 'package:guildwars2_companion/models/trading_post/listing.dart';
import 'package:guildwars2_companion/models/trading_post/price.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';
import 'package:guildwars2_companion/utils/dio.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class TradingPostRepository {

  Dio _dio;

  TradingPostRepository() {
    _dio = DioUtil.getDioInstance();
  }

  Future<TradingPostPrice> getItemPrice(int itemId) async {
    final response = await _dio.get(Urls.tradingPostPriceUrl + itemId.toString());

    if (response.statusCode == 200) {
      return TradingPostPrice.fromJson(response.data);
    }

    throw Exception('Failed to load item price');
  }

  Future<TradingPostDelivery> getDelivery() async {
    final response = await _dio.get(Urls.tradingPostDeliveryUrl);

    if (response.statusCode == 200) {
      return TradingPostDelivery.fromJson(response.data);
    }

    return TradingPostDelivery(
      coins: 0,
      items: []
    );
  }

  Future<List<TradingPostTransaction>> getTransactions(String time, String type) async {
    final response = await _dio.get('${Urls.tradingPostTransactionsUrl}$time/$type');

    if (response.statusCode == 200) {
      List transactions = response.data;
      return transactions.map((a) => TradingPostTransaction.fromJson(a)).toList();
    }

    return [];
  }

  Future<TradingPostListing> getListing(int itemId) async {
    final response = await _dio.get(Urls.tradingPostListingsUrl + itemId.toString());

    if (response.statusCode == 200 || response.statusCode == 206) {
      return TradingPostListing.fromJson(response.data);
    }

    return null;
  }
}