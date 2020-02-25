import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../migrations/item.dart';
import '../migrations/mini.dart';
import '../migrations/skin.dart';
import '../models/items/item.dart';
import '../models/items/skin.dart';
import '../models/other/mini.dart';
import '../utils/urls.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class ItemService {
  List<Item> _cachedItems;
  List<Skin> _cachedSkins;
  List<Mini> _cachedMinis;

  Dio dio;

  ItemService({
    @required this.dio,
  });

  Future<Database> _getItemDatabase() async {
    return await openDatabaseWithMigration(
      join(await getDatabasesPath(), 'items.db'),
      ItemMigrations.config
    );
  }

  Future<Database> _getSkinDatabase() async {
    return await openDatabaseWithMigration(
      join(await getDatabasesPath(), 'skins.db'),
      SkinMigrations.config
    );
  }

  Future<Database> _getMiniDatabase() async {
    return await openDatabaseWithMigration(
      join(await getDatabasesPath(), 'minis.db'),
      MiniMigrations.config
    );
  }

  Future<void> loadCachedData() async {
    Database itemDatabase = await _getItemDatabase();
    Database skinDatabase = await _getSkinDatabase();
    Database miniDatabase = await _getMiniDatabase();

    DateTime now = DateTime.now().toUtc();

    await itemDatabase.delete(
      'items',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    await skinDatabase.delete(
      'skins',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    await miniDatabase.delete(
      'minis',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    final List<Map<String, dynamic>> items = await itemDatabase.query('items');
    _cachedItems = List.generate(items.length, (i) => Item.fromDb(items[i]));

    final List<Map<String, dynamic>> skins = await skinDatabase.query('skins');
    _cachedSkins = List.generate(skins.length, (i) => Skin.fromDb(skins[i]));

    final List<Map<String, dynamic>> minis = await miniDatabase.query('minis');
    _cachedMinis = List.generate(minis.length, (i) => Mini.fromDb(minis[i]));

    itemDatabase.close();
    skinDatabase.close();
    miniDatabase.close();

    return;
  }

  Future<void> clearCache() async {
    Database itemDatabase = await _getItemDatabase();
    Database skinDatabase = await _getSkinDatabase();
    Database miniDatabase = await _getMiniDatabase();

    await itemDatabase.delete(
      'items',
    );

    await skinDatabase.delete(
      'skins',
    );

    await miniDatabase.delete(
      'minis',
    );

    _cachedItems.clear();
    _cachedSkins.clear();
    _cachedMinis.clear();
    
    return;
  }

  int getCachedItemsCount() {
    return _cachedItems.length;
  }

  int getCachedSkinsCount() {
    return _cachedSkins.length;
  }

  int getCachedMinisCount() {
    return _cachedMinis.length;
  }

  Future<List<Item>> getItems(List<int> itemIds) async {
    List<Item> items = [];
    List<int> newItemIds = [];

    itemIds.forEach((itemId) {
      Item item = _cachedItems.firstWhere((i) => i.id == itemId, orElse: () => null);

      if (item != null) {
        items.add(item);
      } else {
        newItemIds.add(itemId);
      }
    });

    if (newItemIds.isNotEmpty) {
      items.addAll(await _getNewItems(newItemIds));
    }

    return items;
  }

  Future<List<Item>> _getNewItems(List<int> itemIds) async {
    List<String> itemIdsList = Urls.divideIdLists(itemIds);
    List<Item> items = [];
    for (var itemIdsString in itemIdsList) {
      final response = await dio.get(Urls.itemsUrl + itemIdsString);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseItems = response.data;
        items.addAll(reponseItems.map((a) => Item.fromJson(a)).toList());
        continue;
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheItems(items);

    return items;
  }

  Future<void> _cacheItems(List<Item> items) async {
    Database database = await _getItemDatabase();

    List<Item> nonCachedItems = items.where((i) => !_cachedItems.any((ci) => ci.id == i.id)).toList();
    _cachedItems.addAll(nonCachedItems);

    String expirationDate = DateFormat('yyyyMMdd')
      .format(
        DateTime
        .now()
        .add(Duration(days: 31))
        .toUtc()
      );

    Batch batch = database.batch();
    nonCachedItems.forEach((item) => batch.insert('items', item.toDb(expirationDate), conflictAlgorithm: ConflictAlgorithm.ignore));
    await batch.commit(noResult: true);

    database.close();

    return;
  }

  Future<List<Skin>> getSkins(List<int> skinIds) async {
    List<Skin> skins = [];
    List<int> newSkinIds = [];

    skinIds.forEach((skinId) {
      Skin skin = _cachedSkins.firstWhere((i) => i.id == skinId, orElse: () => null);

      if (skin != null) {
        skins.add(skin);
      } else {
        newSkinIds.add(skinId);
      }
    });

    if (newSkinIds.isNotEmpty) {
      skins.addAll(await _getNewSkins(newSkinIds));
    }

    return skins;
  }

  Future<List<Skin>> _getNewSkins(List<int> skinIds) async {
    List<String> skinIdsList = Urls.divideIdLists(skinIds);
    List<Skin> skins = [];
    for (var skinIds in skinIdsList) {
      final response = await dio.get(Urls.skinsUrl + skinIds);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseSkins = response.data;
        skins.addAll(reponseSkins.map((a) => Skin.fromJson(a)).toList());
        continue;
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheSkins(skins);

    return skins;
  }

  Future<void> _cacheSkins(List<Skin> skins) async {
    Database database = await _getSkinDatabase();

    List<Skin> nonCachedSkins = skins.where((s) => !_cachedSkins.any((cs) => cs.id == s.id)).toList();
    _cachedSkins.addAll(nonCachedSkins);

    String expirationDate = DateFormat('yyyyMMdd')
      .format(
        DateTime
        .now()
        .add(Duration(days: 31))
        .toUtc()
      );

    Batch batch = database.batch();
    nonCachedSkins.forEach((skin) => batch.insert('skins', skin.toDb(expirationDate), conflictAlgorithm: ConflictAlgorithm.ignore));
    await batch.commit(noResult: true);

    database.close();

    return;
  }

  Future<List<Mini>> getMinis(List<int> miniIds) async {
    List<Mini> minis = [];
    List<int> newMiniIds = [];

    miniIds.forEach((miniId) {
      Mini mini = _cachedMinis.firstWhere((i) => i.id == miniId, orElse: () => null);

      if (mini != null) {
        minis.add(mini);
      } else {
        newMiniIds.add(miniId);
      }
    });

    if (newMiniIds.isNotEmpty) {
      minis.addAll(await _getNewMinis(newMiniIds));
    }

    return minis;
  }

  Future<List<Mini>> _getNewMinis(List<int> miniIds) async {
    List<String> miniIdsList = Urls.divideIdLists(miniIds);
    List<Mini> minis = [];
    for (var skinIds in miniIdsList) {
      final response = await dio.get(Urls.minisUrl + skinIds);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseMinis = response.data;
        minis.addAll(reponseMinis.map((a) => Mini.fromJson(a)).toList());
        continue;
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheMinis(minis);

    return minis;
  }

  Future<void> _cacheMinis(List<Mini> minis) async {
    Database database = await _getMiniDatabase();

    List<Mini> nonCachedMinis = minis.where((m) => !_cachedMinis.any((cm) => cm.id == m.id)).toList();
    _cachedMinis.addAll(nonCachedMinis);

    String expirationDate = DateFormat('yyyyMMdd')
      .format(
        DateTime
        .now()
        .add(Duration(days: 31))
        .toUtc()
      );

    Batch batch = database.batch();
    nonCachedMinis.forEach((mini) => batch.insert('minis', mini.toDb(expirationDate), conflictAlgorithm: ConflictAlgorithm.ignore));
    await batch.commit(noResult: true);

    database.close();

    return;
  }
}
