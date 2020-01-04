import 'package:guildwars2_companion/models/trading_post/delivery.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';
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

  final bool listingsLoaded;
  final bool listingsLoading;

  LoadedTradingPostState({
    @required this.buying,
    @required this.selling,
    @required this.bought,
    @required this.sold,
    @required this.tradingPostDelivery,
    this.listingsLoaded = false,
    this.listingsLoading = false,
  });
}