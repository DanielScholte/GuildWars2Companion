import 'dart:convert';

import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/models/achievement/achievement_progress.dart';
import 'package:guildwars2_companion/models/achievement/daily.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:http/http.dart' as http;

class AchievementRepository {
  Future<List<AchievementProgress>> getAchievementProgress() async {
    final response = await http.get(
      Urls.inventoryUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List progress = json.decode(response.body);
      return progress.where((a) => a != null).map((a) => AchievementProgress.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<AchievementCategory>> getAchievementCategories() async {
    final response = await http.get(
      Urls.achievementCategoriesUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List categories = json.decode(response.body);
      return categories.where((a) => a != null).map((a) => AchievementCategory.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<AchievementGroup>> getAchievementGroups() async {
    final response = await http.get(
      Urls.achievementGroupsUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List groups = json.decode(response.body);
      return groups.where((a) => a != null).map((a) => AchievementGroup.fromJson(a)).toList();
    } else {
      return [];
    }
  }

  Future<List<Daily>> getDailies() async {
    final response = await http.get(
      Urls.dailiesUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List dailies = json.decode(response.body);
      return dailies.where((a) => a != null).map((a) => Daily.fromJson(a)).toList();
    } else {
      return [];
    }
  }
}