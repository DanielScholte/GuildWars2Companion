import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/trading_post/trading_post_data.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';
import 'package:guildwars2_companion/repositories/trading_post.dart';
import './bloc.dart';

class TradingPostBloc extends Bloc<TradingPostEvent, TradingPostState> {
  final TradingPostRepository tradingPostRepository;

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

      TradingPostData tradingPostData = await tradingPostRepository.getTradingPostData();

      yield LoadedTradingPostState(
        buying: tradingPostData.buying,
        selling: tradingPostData.selling,
        bought: tradingPostData.bought,
        sold: tradingPostData.sold,
        tradingPostDelivery: tradingPostData.tradingPostDelivery
      );
    } catch (_) {
      yield ErrorTradingPostState();
    }
  }

  Stream<TradingPostState> _loadTradingPostListing(LoadTradingPostListingsEvent event) async* {
    try {
      TradingPostTransaction transaction = _getTradingPostTransaction(state, event.itemId);
      transaction.loading = true;

      yield LoadedTradingPostState(
        buying: event.buying,
        selling: event.selling,
        bought: event.bought,
        sold: event.sold,
        tradingPostDelivery: event.tradingPostDelivery,
      );

      await tradingPostRepository.loadTradingPostListings(transaction);

      if (transaction.listing != null) {
        event.buying.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
        event.selling.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
        event.bought.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
        event.sold.where((t) => t.itemId == event.itemId).forEach((t) => t.listing = transaction.listing);
      }

      yield LoadedTradingPostState(
        buying: event.buying,
        selling: event.selling,
        bought: event.bought,
        sold: event.sold,
        tradingPostDelivery: event.tradingPostDelivery
      );
    } catch (_) {
      yield LoadedTradingPostState(
        buying: event.buying,
        selling: event.selling,
        bought: event.bought,
        sold: event.sold,
        tradingPostDelivery: event.tradingPostDelivery,
        hasError: true
      );
    }
  }

  TradingPostTransaction _getTradingPostTransaction(LoadedTradingPostState state, int itemId) {
    TradingPostTransaction transaction;

    [
      state.buying,
      state.selling,
      state.bought,
      state.sold
    ].forEach((transactionList) {
      if (transaction == null) {
        transaction = transactionList.firstWhere((t) => t.itemId == itemId, orElse: () => null);
      }
    });

    return transaction;
  }
}
