import 'package:guildwars2_companion/features/achievement/models/achievement.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement_group.dart';
import 'package:guildwars2_companion/features/achievement/models/daily.dart';
import 'package:guildwars2_companion/features/mastery/models/mastery.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AchievementState {}
  
class LoadingAchievementsState extends AchievementState {}

class LoadedAchievementsState extends AchievementState {
  final List<AchievementGroup> achievementGroups;
  final DailyGroup dailies;
  final DailyGroup dailiesTomorrow;
  final List<Achievement> achievements;
  final List<Achievement> favoriteAchievements;
  final List<Mastery> masteries;
  final bool includesProgress;
  final int achievementPoints;
  final int masteryLevel;
  final bool hasError;

  LoadedAchievementsState({
    @required this.achievementGroups,
    @required this.dailies,
    @required this.dailiesTomorrow,
    @required this.achievements,
    @required this.favoriteAchievements,
    @required this.masteries,
    @required this.includesProgress,
    @required this.achievementPoints,
    @required this.masteryLevel,
    this.hasError = false,
  });
}

class ErrorAchievementsState extends AchievementState {
  final bool includesProgress;

  ErrorAchievementsState(this.includesProgress);
}