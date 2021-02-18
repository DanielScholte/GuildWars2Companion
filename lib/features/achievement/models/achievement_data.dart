import 'package:guildwars2_companion/features/achievement/models/achievement.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement_group.dart';
import 'package:guildwars2_companion/features/achievement/models/daily.dart';

class AchievementData {
  final List<AchievementGroup> achievementGroups;
  final DailyGroup dailies;
  final DailyGroup dailiesTomorrow;
  final List<Achievement> achievements;
  final List<Achievement> favoriteAchievements;
  final int achievementPoints;

  AchievementData({this.achievementGroups, this.dailies, this.dailiesTomorrow, this.achievements, this.favoriteAchievements, this.achievementPoints});
}