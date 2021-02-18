import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletState {}
  
class LoadingWalletState extends WalletState {}

class LoadedWalletState extends WalletState {
  final List<Currency> currencies;

  LoadedWalletState(this.currencies);
}

class ErrorWalletState extends WalletState {}