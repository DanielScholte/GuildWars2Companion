import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/models/wallet/wallet.dart';
import 'package:guildwars2_companion/services/wallet.dart';

class WalletRepository {
  final WalletService walletService;

  WalletRepository({
    @required this.walletService,
  });

  Future<List<Currency>> getWallet() async {
    List<Currency> currencies = await walletService.getCurrency();
    List<WalletEntry> walletEntries = await walletService.getWallet();

    currencies.forEach((c) {
      WalletEntry walletEntry = walletEntries.firstWhere((w) => w.id == c.id, orElse: () => null);
      if (walletEntry != null) {
        c.value = walletEntry.value;
      } else {
        c.value = 0;
      }
    });

    return currencies.where((c) => c.name != null && c.name.isNotEmpty).toList();
  }
}