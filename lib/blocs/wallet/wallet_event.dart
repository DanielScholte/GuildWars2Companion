import 'package:meta/meta.dart';

@immutable
abstract class WalletEvent {}

class LoadWalletEvent extends WalletEvent {}