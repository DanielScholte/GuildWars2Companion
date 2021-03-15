import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/item/enums/item_section.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/models/item_details.dart';
import 'package:guildwars2_companion/features/item/services/item.dart';

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

  List<ItemDetail> getItemDetails(Item item) => itemService.getItemDetails(item);

  List<String> getFilteredFlags(List<String> flags, ItemSection section) => itemService.getFilteredFlags(flags, section);
}