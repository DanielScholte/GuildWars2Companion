import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/database_configurations/skill.dart';
import 'package:guildwars2_companion/database_configurations/traits.dart';
import 'package:guildwars2_companion/models/build/build.dart';
import 'package:guildwars2_companion/models/build/skill_trait.dart';
import 'package:guildwars2_companion/models/build/specialization.dart';
import 'package:guildwars2_companion/services/cache.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class BuildService {
  final Dio dio;

  CacheService<SkillTrait> _skillCacheService;
  CacheService<SkillTrait> _traitCacheService;

  List<Specialization> _specializations;

  BuildService({
    @required this.dio
  }) {
    this._skillCacheService = CacheService<SkillTrait>(
      databaseConfiguration: SkillConfiguration(),
      fromJson: (json) => SkillTrait.fromJson(json),
      fromMap: (map) => SkillTrait.fromDb(map),
      toMap: (skilltrait) => skilltrait.toDb(),
      findById: (skillTraits, id) => skillTraits.firstWhere((a) => a.id == id, orElse: () => null),
      url: Urls.skillsUrl,
      dio: dio,
    );

    this._traitCacheService = CacheService<SkillTrait>(
      databaseConfiguration: TraitConfiguration(),
      fromJson: (json) => SkillTrait.fromJson(json),
      fromMap: (map) => SkillTrait.fromDb(map),
      toMap: (skilltrait) => skilltrait.toDb(),
      findById: (skillTraits, id) => skillTraits.firstWhere((a) => a.id == id, orElse: () => null),
      url: Urls.traitsUrl,
      dio: dio,
    );
  }

  Future<void> loadCachedData() async {
    await _skillCacheService.load();
    await _traitCacheService.load();
  }

  Future<void> clearCache() async {
    await _skillCacheService.clear();
    await _traitCacheService.clear();
  }

  Future<int> getCachedSkillsCount() => _skillCacheService.count();

  Future<int> getCachedTraitsCount() => _traitCacheService.count();

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

  Future<List<SkillTrait>> getSkills(List<int> skillIds) => _skillCacheService.getData(skillIds);

  Future<List<SkillTrait>> getTraits(List<int> traitIds) => _traitCacheService.getData(traitIds);
}