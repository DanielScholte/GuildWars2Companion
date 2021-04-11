import 'package:meta/meta.dart';

@immutable
abstract class TradingPostEvent {}

class LoadTradingPostEvent extends TradingPostEvent {}

class LoadTradingPostListingsEvent extends TradingPostEvent {
  final int itemId;

  LoadTradingPostListingsEvent({
    @required this.itemId,
  });
}