import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/wallet/repositories/wallet.dart';
import './bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;

  WalletBloc({
    @required this.walletRepository
  }): super(LoadingWalletState());

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
