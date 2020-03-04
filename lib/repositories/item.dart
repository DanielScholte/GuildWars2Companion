import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/services/item.dart';

class ItemRepository {
  final ItemService itemService;

  ItemRepository({
    @required this.itemService,
  });

  Future<void> clearCache() {
    return itemService.clearCache();
  }

  int getCachedItemsCount() {
    return itemService.getCachedItemsCount();
  }

  int getCachedSkinsCount() {
    return itemService.getCachedSkinsCount();
  }

  int getCachedMinisCount() {
    return itemService.getCachedMinisCount();
  }
}