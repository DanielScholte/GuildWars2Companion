import 'package:guildwars2_companion/models/trading_post/delivery.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TradingPostEvent {}

class LoadTradingPostEvent extends TradingPostEvent {}

class LoadTradingPostListingsEvent extends TradingPostEvent {
  final List<TradingPostTransaction> buying;
  final List<TradingPostTransaction> selling;
  final List<TradingPostTransaction> bought;
  final List<TradingPostTransaction> sold;
  final TradingPostDelivery tradingPostDelivery;

  LoadTradingPostListingsEvent({
    @required this.buying,
    @required this.selling,
    @required this.bought,
    @required this.sold,
    @required this.tradingPostDelivery,
  });
}