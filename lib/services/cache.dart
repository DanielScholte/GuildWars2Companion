import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/database_configurations/base.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class CacheService<T> {
  List<T> _data;

  final DatabaseConfiguration databaseConfiguration;
  final T Function(Map<String, dynamic>) fromJson;
  final T Function(Map<String, dynamic>) fromMap;
  final Map<String, dynamic> Function(T) toMap;
  final T Function(List<T>, int) findById;
  final String url;
  final Dio dio;

  CacheService({
    @required this.databaseConfiguration,
    @required this.fromJson,
    @required this.fromMap,
    @required this.toMap,
    @required this.findById,
    @required this.url,
    @required this.dio,
  });

  Future<void> load() async {
    if (_data != null) {
      return;
    }

    Database database = await _getDatabase();

    DateTime now = DateTime.now().toUtc();

    await database.delete(
      databaseConfiguration.tableName,
      where: "cache_expiration_date <= ? OR cache_version < ? ",
      whereArgs: [
        DateFormat('yyyyMMdd').format(now),
        databaseConfiguration.migrationConfig.migrationScripts.length
      ],
    );

    final List<Map<String, dynamic>> data = await database.query(databaseConfiguration.tableName);
    _data = List.generate(data.length, (i) => fromMap(data[i]));

    database.close();

    return;
  }

  Future<void> clear() async {
    Database database = await _getDatabase();

    await database.delete(
      databaseConfiguration.tableName,
    );

    _data?.clear();

    database.close();
    
    return;
  }

  Future<int> count() async {
    if (_data == null) {
      Database database = await _getDatabase();

      var count = await database.rawQuery(
        'SELECT COUNT (*) from ${databaseConfiguration.tableName}',
      );

      database.close();

      return Sqflite.firstIntValue(count);
    }

    return _data.length;
  }

  Future<List<T>> getData(List<int> ids) async {
    List<T> data = [];
    List<int> newIds = [];

    ids.forEach((id) {
      T object = findById(_data, id);

      if (object != null) {
        data.add(object);
      } else {
        newIds.add(id);
      }
    });

    if (newIds.isNotEmpty) {
      data.addAll(await _getNewData(newIds));
    }

    return data;
  }

  Future<List<T>> _getNewData(List<int> ids) async {
    List<String> idsStringList = Urls.divideIdLists(ids);
    List<T> data = [];

    for (var idsString in idsStringList) {
      final response = await dio.get(url + idsString);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List responseData = response.data;
        data.addAll(responseData.map((a) => fromJson(a)));
        continue;
      }

      if (response.statusCode != 404) {
        throw Exception("Failed to get ${databaseConfiguration.tableName} with ids $idsString");
      }
    }

    if (data.length == 0) {
      return [];
    }

    Database database = await _getDatabase();

    String expirationDate = DateFormat('yyyyMMdd')
      .format(
        DateTime
        .now()
        .add(Duration(days: 31))
        .toUtc()
      );
    int version = databaseConfiguration.migrationConfig.migrationScripts.length;

    Batch batch = database.batch();

    data.forEach((object) {
      Map<String, dynamic> map = toMap(object);
      
      map['cache_expiration_date'] = expirationDate;
      map['cache_version'] = version;

      batch.insert(
        databaseConfiguration.tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    });

    await batch.commit(noResult: true);

    database.close();

    _data.addAll(data);

    return data;
  }

  Future<Database> _getDatabase() async {
    return await openDatabaseWithMigration(
      await databaseConfiguration.getPath(),
      databaseConfiguration.migrationConfig
    );
  }
}