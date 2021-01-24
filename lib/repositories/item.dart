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

  Future<int> getCachedItemsCount() => itemService.getCachedItemsCount();

  Future<int> getCachedSkinsCount() => itemService.getCachedSkinsCount();

  Future<int> getCachedMinisCount() => itemService.getCachedMinisCount();
}