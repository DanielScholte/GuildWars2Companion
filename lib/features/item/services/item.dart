import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/core/services/cache.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/item/database_configurations/item.dart';
import 'package:guildwars2_companion/features/item/database_configurations/mini.dart';
import 'package:guildwars2_companion/features/item/database_configurations/skin.dart';
import 'package:guildwars2_companion/features/item/enums/item_section.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/models/item_details.dart';
import 'package:guildwars2_companion/features/item/models/mini.dart';
import 'package:guildwars2_companion/features/item/models/skin.dart';

class ItemService {
  final Dio dio;

  CacheService<Item> _itemCacheService;
  CacheService<Skin> _skinCacheService;
  CacheService<Mini> _miniCacheService;

  ItemService({
    @required this.dio,
  }) {
    this._itemCacheService = CacheService<Item>(
      databaseConfiguration: ItemConfiguration(),
      fromJson: (json) => Item.fromJson(json),
      fromMap: (map) => Item.fromDb(map),
      toMap: (item) => item.toDb(),
      findById: (items, id) => items.firstWhere((a) => a.id == id, orElse: () => null),
      url: Urls.itemsUrl,
      dio: dio,
    );

    this._skinCacheService = CacheService<Skin>(
      databaseConfiguration: SkinConfiguration(),
      fromJson: (json) => Skin.fromJson(json),
      fromMap: (map) => Skin.fromDb(map),
      toMap: (skin) => skin.toDb(),
      findById: (skins, id) => skins.firstWhere((a) => a.id == id, orElse: () => null),
      url: Urls.skinsUrl,
      dio: dio,
    );

    this._miniCacheService = CacheService<Mini>(
      databaseConfiguration: MiniConfiguration(),
      fromJson: (json) => Mini.fromJson(json),
      fromMap: (map) => Mini.fromDb(map),
      toMap: (mini) => mini.toDb(),
      findById: (minis, id) => minis.firstWhere((a) => a.id == id, orElse: () => null),
      url: Urls.minisUrl,
      dio: dio,
    );
  }

  Future<void> loadCachedData() async {
    await _itemCacheService.load();
    await _skinCacheService.load();
    await _miniCacheService.load();
  }

  Future<void> clearCache() async {
    await _itemCacheService.clear();
    await _skinCacheService.clear();
    await _miniCacheService.clear();
  }

  Future<int> getCachedItemsCount() => _itemCacheService.count();

  Future<int> getCachedSkinsCount() => _skinCacheService.count();

  Future<int> getCachedMinisCount() => _miniCacheService.count();

  Future<List<Item>> getItems(List<int> itemIds) => _itemCacheService.getData(itemIds);

  Future<List<Skin>> getSkins(List<int> skinIds) => _skinCacheService.getData(skinIds);

  Future<List<Mini>> getMinis(List<int> miniIds) => _miniCacheService.getData(miniIds);

  List<ItemDetail> getItemDetails(Item item) {
    List<ItemDetail> details = [
      ItemDetail('Rarity', item.rarity)
    ];

    switch (item.type) {
      case 'Armor':
        details.addAll([
          ItemDetail('Type', GuildWarsUtil.itemTypeToName(item.type)),
          ItemDetail('Weight Class', GuildWarsUtil.itemTypeToName(item.details.weightClass)),
          ItemDetail('Defense', GuildWarsUtil.intToString(item.details.defense)),
        ]);
        break;
      case 'Bag':
        details.addAll([
          ItemDetail('Size', GuildWarsUtil.intToString(item.details.size)),
        ]);
        break;
      case 'Consumable':
        details.addAll([
          ItemDetail('Type', GuildWarsUtil.itemTypeToName(item.type)),
          if (item.details.durationMs != null)
            ItemDetail('Duration', GuildWarsUtil.durationToTextString(Duration(milliseconds: item.details.durationMs))),
          if (item.details.name != null)
            ItemDetail('Effect Type', item.details.name)
        ]);
        break;
      case 'Gathering':
      case 'Trinket':
      case 'UpgradeComponent':
        details.addAll([
          ItemDetail('Type', GuildWarsUtil.itemTypeToName(item.type))
        ]);
        break;
      case 'Tool':
        details.addAll([
          ItemDetail('Charges', GuildWarsUtil.intToString(item.details.charges))
        ]);
        break;
      case 'Weapon':
        details.addAll([
          ItemDetail('Type', GuildWarsUtil.itemTypeToName(item.type)),
          ItemDetail('Weapon Strength', '${GuildWarsUtil.intToString(item.details.minPower)} - ${GuildWarsUtil.intToString(item.details.maxPower)}'),
          if (item.details.defense != null && item.details.defense > 0)
            ItemDetail('Defense', GuildWarsUtil.intToString(item.details.defense)),
        ]);
        break;
    }

    return details;
  }

  List<String> getFilteredFlags(List<String> flags, ItemSection section) {
    if (flags == null) return [];

    List<String> filteredFlags = flags.where((f) {
      if (f.isEmpty) {
        return false;
      }

      switch (section) {
        case ItemSection.EQUIPMENT:
          if (f == 'HideSuffix') return false;
          return true;
        case ItemSection.BANK:
          if (f == 'NoUnderwater' || f == 'DeleteWarning' || f == 'HideSuffix') return false;
          return true;
        case ItemSection.INVENTORY:
          if (f == 'HideSuffix') return false;
          return true;
        case ItemSection.MATERIAL:
          return f != 'NoUnderwater'
              && f != 'HideSuffix';
        case ItemSection.TRADING_POST:
        default: return f != 'HideSuffix';
      }
    }).toList();

    // modify flags based on existence (or not) of another in the filtered list
    if (section == ItemSection.EQUIPMENT) {
      if (filteredFlags.contains('AccountBound')) {
        filteredFlags.remove('AccountBindOnUse');
      }
      if (filteredFlags.contains('SoulBindOnUse')) {
        filteredFlags.remove('SoulBindOnUse');
        filteredFlags.add('Soulbound'); // this is a non-API flag for display
      }
      if (filteredFlags.contains("AccountBindOnUse")) {
        filteredFlags.remove("AccountBindOnUse");
        filteredFlags.remove("AccountBound");
        filteredFlags.add("AccountBound");
      }
    }
    if (filteredFlags.contains('AccountBound') && filteredFlags.contains('AccountBindOnUse') && section == ItemSection.INVENTORY) {
      filteredFlags.remove('AccountBindOnUse');
    }

    filteredFlags.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return filteredFlags;
  }
}
