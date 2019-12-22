import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/models/wallet/wallet.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  @override
  WalletState get initialState => LoadingWalletState();

  @override
  Stream<WalletState> mapEventToState(
    WalletEvent event,
  ) async* {
    if (event is LoadWalletEvent) {
      yield LoadingWalletState();

      List<Currency> currencies = await _getCurrency();
      List<WalletEntry> walletEntries = await _getWallet();

      currencies.forEach((c) {
        WalletEntry walletEntry = walletEntries.firstWhere((w) => w.id == c.id, orElse: () => null);
        if (walletEntry != null) {
          c.value = walletEntry.value;
        } else {
          c.value = 0;
        }
      });

      yield LoadedWalletState(currencies);
    }
  }

  Future<List<Currency>> _getCurrency() async {
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

  Future<List<WalletEntry>> _getWallet() async {
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
