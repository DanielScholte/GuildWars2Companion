import 'package:dio/dio.dart';
import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/models/achievement/achievement_progress.dart';
import 'package:guildwars2_companion/models/achievement/daily.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/models/mastery/mastery_progress.dart';
import 'package:guildwars2_companion/utils/dio.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AchievementRepository {
  List<Achievement> _cachedAchievements = [];

  Dio _dio;

  AchievementRepository() {
    _dio = DioUtil.getDioInstance();
  }

  Future<Database> _getDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'achievements.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE achievements(
            id INTEGER PRIMARY KEY,
            icon TEXT,
            name TEXT,
            description TEXT,
            requirement TEXT,
            lockedText TEXT,
            prerequisites TEXT,
            pointCap INTEGER,
            bits TEXT,
            tiers TEXT,
            rewards TEXT,
            expiration_date DATE
          )
        ''');
        return;
      },
      version: 1,
    );
  }

  Future<void> loadCachedData() async {
    if (_cachedAchievements.isNotEmpty) {
      return;
    }

    Database database = await _getDatabase();

    DateTime now = DateTime.now().toUtc();

    await database.delete(
      'achievements',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    final List<Map<String, dynamic>> achievements = await database.query('achievements');
    _cachedAchievements = List.generate(achievements.length, (i) => Achievement.fromDb(achievements[i]));

    return;
  }

  int getCachedAchievementsCount() {
    return _cachedAchievements.length;
  }

  Future<List<Achievement>> getAchievements(List<int> achievementIds) async {
    List<Achievement> achievements = [];
    List<int> newAchievementIds = [];

    achievementIds.forEach((achievementId) {
      Achievement item = _cachedAchievements.firstWhere((i) => i.id == achievementId, orElse: () => null);

      if (item != null) {
        achievements.add(item);
      } else {
        newAchievementIds.add(achievementId);
      }
    });

    if (newAchievementIds.isNotEmpty) {
      achievements.addAll(await _getNewAchievements(newAchievementIds));
    }

    return achievements;
  }

  Future<List<Achievement>> _getNewAchievements(List<int> achievementIds) async {
    List<String> achievementIdsList = Urls.divideIdLists(achievementIds);
    List<Achievement> achievements = [];
    for (var achievementIdsString in achievementIdsList) {
      final response = await _dio.get(Urls.achievementsUrl + achievementIdsString);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List responseAchievements = response.data;
        achievements.addAll(responseAchievements.map((a) => Achievement.fromJson(a)).toList());
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheAchievements(achievements);

    return achievements;
  }

  Future<void> _cacheAchievements(List<Achievement> achievements) async {
    Database database = await _getDatabase();

    List<Achievement> nonCachedItems = achievements.where((i) => !_cachedAchievements.any((ca) => ca.id == i.id)).toList();
    _cachedAchievements.addAll(nonCachedItems);

    String expirationDate = DateFormat('yyyyMMdd')
      .format(
        DateTime
        .now()
        .add(Duration(days: 31))
        .toUtc()
      );

    Batch batch = database.batch();
    nonCachedItems.forEach((achievement) =>
      batch.insert('achievements', achievement.toDb(expirationDate), conflictAlgorithm: ConflictAlgorithm.ignore));
    await batch.commit(noResult: true);

    return;
  }

  Future<List<AchievementProgress>> getAchievementProgress() async {
    final response = await _dio.get(Urls.achievementProgressUrl);

    if (response.statusCode == 200) {
      List progress = response.data;
      return progress.where((a) => a != null).map((a) => AchievementProgress.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<AchievementCategory>> getAchievementCategories() async {
    final response = await _dio.get(Urls.achievementCategoriesUrl);

    if (response.statusCode == 200) {
      List categories = response.data;
      return categories.where((a) => a != null).map((a) => AchievementCategory.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<AchievementGroup>> getAchievementGroups() async {
    final response = await _dio.get(Urls.achievementGroupsUrl);

    if (response.statusCode == 200) {
      List groups = response.data;
      return groups.where((a) => a != null).map((a) => AchievementGroup.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<DailyGroup> getDailies({bool tomorrow = false}) async {
    final response = await _dio.get(tomorrow ? Urls.dailiesTomorrowUrl : Urls.dailiesUrl);

    if (response.statusCode == 200) {
      return DailyGroup.fromJson(response.data);
    }

    throw Exception();
  }

  Future<List<Mastery>> getMasteries() async {
    final response = await _dio.get(Urls.masteriesUrl);

    if (response.statusCode == 200) {
      List masteries = response.data;
      return masteries.map((a) => Mastery.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<MasteryProgress>> getMasteryProgress() async {
    final response = await _dio.get(Urls.masteryProgressUrl);

    if (response.statusCode == 200) {
      List masteries = response.data;
      return masteries.map((a) => MasteryProgress.fromJson(a)).toList();
    }

    throw Exception();
  }
}