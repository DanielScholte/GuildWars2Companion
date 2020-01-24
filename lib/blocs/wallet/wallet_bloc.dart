import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
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
      try {
        yield LoadingWalletState();

        yield LoadedWalletState(await walletRepository.getWallet());
      } catch (_) {
        yield ErrorWalletState();
      }
    }
  }
}
