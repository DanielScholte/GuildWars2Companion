import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/models/wallet/wallet.dart';
import 'package:guildwars2_companion/repositories/wallet.dart';
import './bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  @override
  WalletState get initialState => LoadingWalletState();

  final WalletRepository walletRepository;

  WalletBloc({
    @required this.walletRepository
  });

  @override
  Stream<WalletState> mapEventToState(
    WalletEvent event,
  ) async* {
    if (event is LoadWalletEvent) {
      yield LoadingWalletState();

      List<Currency> currencies = await walletRepository.getCurrency();
      List<WalletEntry> walletEntries = await walletRepository.getWallet();

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
}
