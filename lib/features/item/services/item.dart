import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/core/services/cache.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/item/database_configurations/item.dart';
import 'package:guildwars2_companion/features/item/database_configurations/mini.dart';
import 'package:guildwars2_companion/features/item/database_configurations/skin.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
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
}
