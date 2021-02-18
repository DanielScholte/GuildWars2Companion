import 'package:guildwars2_companion/models/trading_post/delivery.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';

class TradingPostData {
  final List<TradingPostTransaction> buying;
  final List<TradingPostTransaction> selling;
  final List<TradingPostTransaction> bought;
  final List<TradingPostTransaction> sold;
  final TradingPostDelivery tradingPostDelivery;

  TradingPostData({this.buying, this.selling, this.bought, this.sold, this.tradingPostDelivery});
}