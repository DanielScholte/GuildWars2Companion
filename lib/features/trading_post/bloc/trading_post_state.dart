import 'package:guildwars2_companion/features/trading_post/models/delivery.dart';
import 'package:guildwars2_companion/features/trading_post/models/transaction.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TradingPostState {}
  
class LoadingTradingPostState extends TradingPostState {}

class LoadedTradingPostState extends TradingPostState {
  final List<TradingPostTransaction> buying;
  final List<TradingPostTransaction> selling;
  final List<TradingPostTransaction> bought;
  final List<TradingPostTransaction> sold;
  final TradingPostDelivery tradingPostDelivery;
  final bool hasError;

  LoadedTradingPostState({
    @required this.buying,
    @required this.selling,
    @required this.bought,
    @required this.sold,
    @required this.tradingPostDelivery,
    this.hasError = false
  });
}

class ErrorTradingPostState extends TradingPostState {}