import 'package:guildwars2_companion/features/trading_post/models/delivery.dart';
import 'package:guildwars2_companion/features/trading_post/models/transaction.dart';

class TradingPostData {
  final List<TradingPostTransaction> buying;
  final List<TradingPostTransaction> selling;
  final List<TradingPostTransaction> bought;
  final List<TradingPostTransaction> sold;
  final TradingPostDelivery tradingPostDelivery;

  TradingPostData({this.buying, this.selling, this.bought, this.sold, this.tradingPostDelivery});
}