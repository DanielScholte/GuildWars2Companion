import 'package:dio/dio.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/models/wallet/wallet.dart';
import 'package:guildwars2_companion/utils/dio.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class WalletRepository {

  Dio _dio;

  WalletRepository() {
    _dio = DioUtil.getDioInstance();
  }

  Future<List<Currency>> getCurrency() async {
    final response = await _dio.get(Urls.currencyUrl);

    if (response.statusCode == 200) {
      List currencies = response.data;
      return currencies.map((a) => Currency.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<WalletEntry>> getWallet() async {
    final response = await _dio.get(Urls.walletUrl);

    if (response.statusCode == 200) {
      List walletEntries = response.data;
      return walletEntries.map((a) => WalletEntry.fromJson(a)).toList();
    }

    throw Exception();
  }
}