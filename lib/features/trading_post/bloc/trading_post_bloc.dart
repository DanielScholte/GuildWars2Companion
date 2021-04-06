import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/trading_post/models/trading_post_data.dart';
import 'package:guildwars2_companion/features/trading_post/models/transaction.dart';
import 'package:guildwars2_companion/features/trading_post/repositories/trading_post.dart';
import './bloc.dart';

class TradingPostBloc extends Bloc<TradingPostEvent, TradingPostState> {
  final TradingPostRepository tradingPostRepository;

  TradingPostData _tradingPostData;

  TradingPostBloc({
    @required this.tradingPostRepository,
  }): super(LoadingTradingPostState());

  @override
  Stream<TradingPostState> mapEventToState(
    TradingPostEvent event,
  ) async* {
    if (event is LoadTradingPostEvent) {
      yield* _loadTradingPost();
    } else if (event is LoadTradingPostListingsEvent) {
      yield* _loadTradingPostListing(event);
    }
  }

  Stream<TradingPostState> _loadTradingPost() async* {
    try {
      yield LoadingTradingPostState();

      _tradingPostData = await tradingPostRepository.getTradingPostData();

      yield _getLoadedTradingPostState();
    } catch (_) {
      yield ErrorTradingPostState();
    }
  }

  Stream<TradingPostState> _loadTradingPostListing(LoadTradingPostListingsEvent event) async* {
    try {
      TradingPostTransaction transaction = _getTradingPostTransaction(event.itemId);
      transaction.loading = true;

      yield _getLoadedTradingPostState();

      await tradingPostRepository.loadTradingPostListings(transaction);

      if (transaction.listing != null) {
        _tradingPostData.buying.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
        _tradingPostData.selling.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
        _tradingPostData.bought.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
        _tradingPostData.sold.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
      }

      yield _getLoadedTradingPostState();
    } catch (_) {
      yield _getLoadedTradingPostState(hasError: true);
    }
  }

  LoadedTradingPostState _getLoadedTradingPostState({ bool hasError = false }) {
    return LoadedTradingPostState(
      bought: _tradingPostData.bought,
      buying: _tradingPostData.buying,
      selling: _tradingPostData.selling,
      sold: _tradingPostData.sold,
      tradingPostDelivery: _tradingPostData.tradingPostDelivery,
      hasError: hasError
    );
  }

  TradingPostTransaction _getTradingPostTransaction(int itemId) {
    TradingPostTransaction transaction;

    [
      _tradingPostData.buying,
      _tradingPostData.selling,
      _tradingPostData.bought,
      _tradingPostData.sold
    ].forEach((transactionList) {
      if (transaction == null) {
        transaction = transactionList.firstWhere((t) => t.itemId == itemId, orElse: () => null);
      }
    });

    return transaction;
  }
}
