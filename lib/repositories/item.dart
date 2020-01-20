import 'package:dio/dio.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/models/other/mini.dart';
import 'package:guildwars2_companion/utils/dio.dart';
import 'package:guildwars2_companion/utils/urls.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ItemRepository {
  List<Item> _cachedItems;
  List<Skin> _cachedSkins;
  List<Mini> _cachedMinis;

  Dio _dio;

  ItemRepository() {
    _dio = DioUtil.getDioInstance();
  }

  Future<Database> _getDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'items.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE skins(
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            rarity TEXT,
            icon TEXT,
            expiration_date DATE
          )
        ''');
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            type TEXT,
            rarity TEXT,
            icon TEXT,
            level INTEGER,
            vendorValue INTEGER,
            expiration_date DATE,
            details_type TEXT,
            details_description TEXT,
            details_weightClass TEXT,
            details_unlockType TEXT,
            details_name TEXT,
            details_defense INTEGER,
            details_size INTEGER,
            details_durationMs INTEGER,
            details_charges INTEGER,
            details_minPower INTEGER,
            details_maxPower INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE minis(
            id INTEGER PRIMARY KEY,
            name TEXT,
            icon TEXT,
            display_order INTEGER,
            itemId INTEGER,
            expiration_date DATE
          )
        ''');
        return;
      },
      version: 1,
    );
  }

  Future<void> loadCachedData() async {
    Database database = await _getDatabase();

    DateTime now = DateTime.now().toUtc();

    await database.delete(
      'items',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    await database.delete(
      'skins',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    await database.delete(
      'minis',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    final List<Map<String, dynamic>> items = await database.query('items');
    _cachedItems = List.generate(items.length, (i) => Item.fromDb(items[i]));

    final List<Map<String, dynamic>> skins = await database.query('skins');
    _cachedSkins = List.generate(skins.length, (i) => Skin.fromDb(skins[i]));

    final List<Map<String, dynamic>> minis = await database.query('minis');
    _cachedMinis = List.generate(minis.length, (i) => Mini.fromDb(minis[i]));

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
      final response = await _dio.get(Urls.itemsUrl + itemIdsString);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseItems = response.data;
        items.addAll(reponseItems.map((a) => Item.fromJson(a)).toList());
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheItems(items);

    return items;
  }

  Future<void> _cacheItems(List<Item> items) async {
    Database database = await _getDatabase();

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
      final response = await _dio.get(Urls.skinsUrl + skinIds);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseSkins = response.data;
        skins.addAll(reponseSkins.map((a) => Skin.fromJson(a)).toList());
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheSkins(skins);

    return skins;
  }

  Future<void> _cacheSkins(List<Skin> skins) async {
    Database database = await _getDatabase();

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
      final response = await _dio.get(Urls.minisUrl + skinIds);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseMinis = response.data;
        minis.addAll(reponseMinis.map((a) => Mini.fromJson(a)).toList());
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheMinis(minis);

    return minis;
  }

  Future<void> _cacheMinis(List<Mini> minis) async {
    Database database = await _getDatabase();

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

    return;
  }
}