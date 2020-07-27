import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/migrations/skill.dart';
import 'package:guildwars2_companion/migrations/traits.dart';
import 'package:guildwars2_companion/models/build/build.dart';
import 'package:guildwars2_companion/models/build/skill_trait.dart';
import 'package:guildwars2_companion/models/build/specialization.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class BuildService {
  List<SkillTrait> _cachedSkills;
  List<SkillTrait> _cachedTraits;
  List<Specialization> _specializations;

  Dio dio;

  BuildService({
    @required this.dio
  });

  Future<Database> _getSkillDatabase() async {
    return await openDatabaseWithMigration(
      join(await getDatabasesPath(), 'skills.db'),
      SkillMigrations.config
    );
  }

  Future<Database> _getTraitDatabase() async {
    return await openDatabaseWithMigration(
      join(await getDatabasesPath(), 'traits.db'),
      TraitMigrations.config
    );
  }

  Future<void> loadCachedData() async {
    Database skillDatabase = await _getSkillDatabase();
    Database traitDatabase = await _getTraitDatabase();

    DateTime now = DateTime.now().toUtc();

    await skillDatabase.delete(
      'skills',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    await traitDatabase.delete(
      'traits',
      where: "expiration_date <= ?",
      whereArgs: [DateFormat('yyyyMMdd').format(now)],
    );

    final List<Map<String, dynamic>> skills = await skillDatabase.query('skills');
    _cachedSkills = List.generate(skills.length, (i) => SkillTrait.fromDb(skills[i]));

    final List<Map<String, dynamic>> traits = await traitDatabase.query('traits');
    _cachedTraits = List.generate(traits.length, (i) => SkillTrait.fromDb(traits[i]));

    skillDatabase.close();
    traitDatabase.close();

    return;
  }

  Future<void> clearCache() async {
    Database skillDatabase = await _getSkillDatabase();
    Database traitDatabase = await _getTraitDatabase();

    await skillDatabase.delete(
      'skills',
    );

    await traitDatabase.delete(
      'traits',
    );

    skillDatabase.close();
    traitDatabase.close();

    _cachedSkills.clear();
    _cachedTraits.clear();
    
    return;
  }

  int getCachedSkillsCount() {
    return _cachedSkills.length;
  }

  int getCachedTraitsCount() {
    return _cachedTraits.length;
  }

  Future<List<Specialization>> getSpecializations() async {
    if (_specializations != null && _specializations.isNotEmpty) {
      return _specializations;
    }

    final response = await dio.get(Urls.specializationsUrl);

    if (response.statusCode == 200) {
      List specializations = response.data;
      _specializations = specializations.map((a) => Specialization.fromJson(a)).toList();
      return _specializations;
    }

    throw Exception();
  }

  Future<List<Build>> getBuildStorage() async {
    final response = await dio.get(Urls.buildStorageUrl);

    if (response.statusCode == 200) {
      List builds = response.data;
      return builds.map((a) => Build.fromJson(a)).toList();
    }

    throw Exception();
  }

  Future<List<SkillTrait>> getSkills(List<int> skillIds) async {
    List<SkillTrait> skills = [];
    List<int> newSkillIds = [];

    skillIds.forEach((skillId) {
      SkillTrait skill = _cachedSkills.firstWhere((i) => i.id == skillId, orElse: () => null);

      if (skill != null) {
        skills.add(skill);
      } else {
        newSkillIds.add(skillId);
      }
    });

    if (newSkillIds.isNotEmpty) {
      skills.addAll(await _getNewSkills(newSkillIds));
    }

    return skills;
  }

  Future<List<SkillTrait>> _getNewSkills(List<int> skillIds) async {
    List<String> skillIdsList = Urls.divideIdLists(skillIds);
    List<SkillTrait> skills = [];
    for (var skillIdsString in skillIdsList) {
      final response = await dio.get(Urls.skillsUrl + skillIdsString);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseSkills = response.data;
        skills.addAll(reponseSkills.map((a) => SkillTrait.fromJson(a)).toList());
        continue;
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheSkills(skills);

    return skills;
  }

  Future<void> _cacheSkills(List<SkillTrait> skills) async {
    Database database = await _getSkillDatabase();

    List<SkillTrait> nonCachedSkills = skills.where((i) => !_cachedSkills.any((ci) => ci.id == i.id)).toList();
    _cachedSkills.addAll(nonCachedSkills);

    String expirationDate = DateFormat('yyyyMMdd')
      .format(
        DateTime
        .now()
        .add(Duration(days: 31))
        .toUtc()
      );

    Batch batch = database.batch();
    nonCachedSkills.forEach((skill) => batch.insert('skills', skill.toDb(expirationDate), conflictAlgorithm: ConflictAlgorithm.ignore));
    await batch.commit(noResult: true);

    database.close();

    return;
  }

  Future<List<SkillTrait>> getTraits(List<int> traitIds) async {
    List<SkillTrait> traits = [];
    List<int> newTraitIds = [];

    traitIds.forEach((traitId) {
      SkillTrait skill = _cachedTraits.firstWhere((i) => i.id == traitId, orElse: () => null);

      if (skill != null) {
        traits.add(skill);
      } else {
        newTraitIds.add(traitId);
      }
    });

    if (newTraitIds.isNotEmpty) {
      traits.addAll(await _getNewTraits(newTraitIds));
    }

    return traits;
  }

  Future<List<SkillTrait>> _getNewTraits(List<int> traitIds) async {
    List<String> traitIdsList = Urls.divideIdLists(traitIds);
    List<SkillTrait> traits = [];
    for (var traitIdsString in traitIdsList) {
      final response = await dio.get(Urls.traitsUrl + traitIdsString);

      if (response.statusCode == 200 || response.statusCode == 206) {
        List reponseTraits = response.data;
        traits.addAll(reponseTraits.map((a) => SkillTrait.fromJson(a)).toList());
        continue;
      }

      if (response.statusCode != 404) {
        throw Exception();
      }
    }

    await _cacheTraits(traits);

    return traits;
  }

  Future<void> _cacheTraits(List<SkillTrait> traits) async {
    Database database = await _getTraitDatabase();

    List<SkillTrait> nonCachedTraits = traits.where((i) => !_cachedTraits.any((ci) => ci.id == i.id)).toList();
    _cachedTraits.addAll(nonCachedTraits);

    String expirationDate = DateFormat('yyyyMMdd')
      .format(
        DateTime
        .now()
        .add(Duration(days: 31))
        .toUtc()
      );

    Batch batch = database.batch();
    nonCachedTraits.forEach((trait) => batch.insert('traits', trait.toDb(expirationDate), conflictAlgorithm: ConflictAlgorithm.ignore));
    await batch.commit(noResult: true);

    database.close();

    return;
  }
}