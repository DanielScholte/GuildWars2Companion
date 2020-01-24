import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/trading_post/delivery.dart';
import 'package:guildwars2_companion/models/trading_post/listing.dart';
import 'package:guildwars2_companion/models/trading_post/price.dart';
import 'package:guildwars2_companion/models/trading_post/trading_post_data.dart';
import 'package:guildwars2_companion/models/trading_post/transaction.dart';
import 'package:guildwars2_companion/services/item.dart';
import 'package:guildwars2_companion/services/trading_post.dart';

class TradingPostRepository {
  
  final TradingPostService tradingPostService;
  final ItemService itemService;

  TradingPostRepository({
    @required this.tradingPostService,
    @required this.itemService,
  });

  Future<TradingPostData> getTradingPostData() async {
    List<TradingPostTransaction> buying = await tradingPostService.getTransactions('current', 'buys');
    List<TradingPostTransaction> selling = await tradingPostService.getTransactions('current', 'sells');
    List<TradingPostTransaction> bought = await tradingPostService.getTransactions('history', 'buys');
    List<TradingPostTransaction> sold = await tradingPostService.getTransactions('history', 'sells');
    TradingPostDelivery tradingPostDelivery = await tradingPostService.getDelivery();

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