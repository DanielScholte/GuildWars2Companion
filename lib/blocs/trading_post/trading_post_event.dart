import 'package:meta/meta.dart';

@immutable
abstract class TradingPostEvent {}

class LoadTradingPostEvent extends TradingPostEvent {}