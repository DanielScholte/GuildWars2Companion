import 'dart:convert';

import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/models/wallet/wallet.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:http/http.dart' as http;

class WalletRepository {
  Future<List<Currency>> getCurrency() async {
    final response = await http.get(
      Urls.currencyUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List currencies = json.decode(response.body);
      return currencies.map((a) => Currency.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<WalletEntry>> getWallet() async {
    final response = await http.get(
      Urls.walletUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List walletEntries = json.decode(response.body);
      return walletEntries.map((a) => WalletEntry.fromJson(a)).toList();
    } else {
      return [];
    }
  }
}