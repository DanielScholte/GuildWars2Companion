import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/wallet/models/currency.dart';
import 'package:guildwars2_companion/features/wallet/models/wallet.dart';

class WalletService {
  Dio dio;

  WalletService({
    @required this.dio,
  });

  Future<List<Currency>> getCurrency() async {
    final response = await dio.get(Urls.currencyUrl);

    if (response.statusCode == 200) {
      List currencies = response.data;
      return currencies.map((a) => Currency.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<WalletEntry>> getWallet() async {
    final response = await dio.get(Urls.walletUrl);

    if (response.statusCode == 200) {
      List walletEntries = response.data;
      return walletEntries.map((a) => WalletEntry.fromJson(a)).toList();
    }

    throw Exception();
  }
}
