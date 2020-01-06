import 'dart:convert';

import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ItemRepository {
  List<Item> _cachedItems;
  List<Skin> _cachedSkins;

  Future<Database> getDatabase() async {
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
        return;
      },
      version: 1,
    );
  }

  Future<void> loadCachedData() async {
    Database database = await getDatabase();

    DateTime now = DateTime.now().toUtc();

    await database.delete(
      'items',
      // Use a `where` clause to delete a specific dog.
      where: "expiration_date <= ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    await database.delete(
      'skins',
      // Use a `where` clause to delete a specific dog.
      where: "expiration_date <= ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    final List<Map<String, dynamic>> items = await database.query('items');
    _cachedItems = List.generate(items.length, (i) => Item.fromDb(items[i]));

    final List<Map<String, dynamic>> skins = await database.query('skins');
    _cachedSkins = List.generate(skins.length, (i) => Skin.fromDb(skins[i]));

    return;
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
    for (var itemIds in itemIdsList) {
      final response = await http.get(
        Urls.itemsUrl + itemIds,
        headers: {
          'Authorization': 'Bearer ${await TokenUtil.getToken()}',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseItems = json.decode(response.body);
        items.addAll(reponseItems.map((a) => Item.fromJson(a)).toList());
      }
    }

    await _cacheItems(items);

    return items;
  }

  Future<void> _cacheItems(List<Item> items) async {
    Database database = await getDatabase();

    List<Item> nonCachedItems = items.where((i) => !_cachedItems.any((ci) => ci.id == i.id)).toList();
    _cachedItems.addAll(nonCachedItems);

    Batch batch = database.batch();
    nonCachedItems.forEach((item) => batch.insert('items', item.toDb(), conflictAlgorithm: ConflictAlgorithm.ignore));
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
      final response = await http.get(
        Urls.skinsUrl + skinIds,
        headers: {
          'Authorization': 'Bearer ${await TokenUtil.getToken()}',
        }
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseSkins = json.decode(response.body);
        skins.addAll(reponseSkins.map((a) => Skin.fromJson(a)).toList());
      }
    }

    await _cacheSkins(skins);

    return skins;
  }

  Future<void> _cacheSkins(List<Skin> skins) async {
    Database database = await getDatabase();

    List<Skin> nonCachedSkins = skins.where((s) => !_cachedSkins.any((cs) => cs.id == s.id)).toList();
    _cachedSkins.addAll(nonCachedSkins);

    Batch batch = database.batch();
    nonCachedSkins.forEach((skin) => batch.insert('skins', skin.toDb(), conflictAlgorithm: ConflictAlgorithm.ignore));
    await batch.commit(noResult: true);

    return;
  }
}