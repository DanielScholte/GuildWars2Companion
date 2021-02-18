import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/models/wallet/wallet.dart';
import 'package:guildwars2_companion/features/wallet/services/wallet.dart';

class WalletRepository {
  final WalletService walletService;

  WalletRepository({
    @required this.walletService,
  });

  Future<List<Currency>> getWallet() async {
    List networkResults = await Future.wait([
      walletService.getCurrency(),
      walletService.getWallet()
    ]);

    List<Currency> currencies = networkResults[0];
    List<WalletEntry> walletEntries = networkResults[1];

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