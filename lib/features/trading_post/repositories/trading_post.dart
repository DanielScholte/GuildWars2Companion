import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/services/item.dart';
import 'package:guildwars2_companion/features/trading_post/models/delivery.dart';
import 'package:guildwars2_companion/features/trading_post/models/listing.dart';
import 'package:guildwars2_companion/features/trading_post/models/price.dart';
import 'package:guildwars2_companion/features/trading_post/models/trading_post_data.dart';
import 'package:guildwars2_companion/features/trading_post/models/transaction.dart';
import 'package:guildwars2_companion/features/trading_post/services/trading_post.dart';

class TradingPostRepository {
  
  final TradingPostService tradingPostService;
  final ItemService itemService;

  TradingPostRepository({
    @required this.tradingPostService,
    @required this.itemService,
  });

  Future<TradingPostData> getTradingPostData() async {
    List networkResults = await Future.wait([
      tradingPostService.getTransactions('current', 'buys'),
      tradingPostService.getTransactions('current', 'sells'),
      tradingPostService.getTransactions('history', 'buys'),
      tradingPostService.getTransactions('history', 'sells'),
      tradingPostService.getDelivery()
    ]);

    List<TradingPostTransaction> buying = networkResults[0];
    List<TradingPostTransaction> selling = networkResults[1];
    List<TradingPostTransaction> bought = networkResults[2];
    List<TradingPostTransaction> sold = networkResults[3];
    TradingPostDelivery tradingPostDelivery = networkResults[4];

    List<int> itemIds = [];
    buying.forEach((t) => itemIds.add(t.itemId));
    selling.forEach((t) => itemIds.add(t.itemId));
    bought.forEach((t) => itemIds.add(t.itemId));
    sold.forEach((t) => itemIds.add(t.itemId));
    tradingPostDelivery.items.forEach((d) => itemIds.add(d.id));

    List<Item> items = await itemService.getItems(itemIds.toSet().toList());

    buying.forEach((t) => t.itemInfo = items.firstWhere((i) => i.id == t.itemId, orElse: () => null));
    selling.forEach((t) => t.itemInfo = items.firstWhere((i) => i.id == t.itemId, orElse: () => null));
    bought.forEach((t) => t.itemInfo = items.firstWhere((i) => i.id == t.itemId, orElse: () => null));
    sold.forEach((t) => t.itemInfo = items.firstWhere((i) => i.id == t.itemId, orElse: () => null));
    tradingPostDelivery.items.forEach((d) => d.itemInfo = items.firstWhere((i) => i.id == d.id, orElse: () => null));

    return TradingPostData(
      bought: bought,
      buying: buying,
      selling: selling,
      sold: sold,
      tradingPostDelivery: tradingPostDelivery,
    );
  }

  Future<void> loadTradingPostListings(TradingPostTransaction transaction) async {
    TradingPostListing listing = await tradingPostService.getListing(transaction.itemId);

    transaction.listing = listing;
    transaction.loading = false;

    return;
  }

  Future<TradingPostPrice> getItemPrice(int itemId) {
    return tradingPostService.getItemPrice(itemId);
  }
}