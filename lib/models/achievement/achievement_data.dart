import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/models/achievement/daily.dart';

class AchievementData {
  final List<AchievementGroup> achievementGroups;
  final DailyGroup dailies;
  final DailyGroup dailiesTomorrow;
  final List<Achievement> achievements;
  final int achievementPoints;

  AchievementData({this.achievementGroups, this.dailies, this.dailiesTomorrow, this.achievements, this.achievementPoints});
}