import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/models/achievement/daily.dart';
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AchievementEvent {}

class LoadAchievementsEvent extends AchievementEvent {
  final bool includeProgress;

  LoadAchievementsEvent({
    @required this.includeProgress
  });
}

class LoadAchievementDetailsEvent extends AchievementEvent {
  final List<AchievementGroup> achievementGroups;
  final DailyGroup dialies;
  final DailyGroup dialiesTomorrow;
  final List<Achievement> achievements;
  final List<Achievement> favoriteAchievements;
  final List<Mastery> masteries;
  final bool includeProgress;
  final int achievementId;
  final int achievementPoints;
  final int masteryLevel;

  LoadAchievementDetailsEvent({
    @required this.achievementGroups,
    @required this.dialies,
    @required this.dialiesTomorrow,
    @required this.achievements,
    @required this.favoriteAchievements,
    @required this.masteries,
    @required this.includeProgress,
    @required this.achievementPoints,
    @required this.achievementId,
    @required this.masteryLevel,
  });
}

class RefreshAchievementProgressEvent extends AchievementEvent {
  final List<AchievementGroup> achievementGroups;
  final DailyGroup dialies;
  final DailyGroup dialiesTomorrow;
  final List<Achievement> achievements;
  final List<Achievement> favoriteAchievements;
  final List<Mastery> masteries;
  final bool includeProgress;
  final int achievementId;
  final int achievementPoints;
  final int masteryLevel;

  RefreshAchievementProgressEvent({
    @required this.achievementGroups,
    @required this.dialies,
    @required this.dialiesTomorrow,
    @required this.achievements,
    @required this.favoriteAchievements,
    @required this.masteries,
    @required this.includeProgress,
    @required this.achievementPoints,
    @required this.achievementId,
    @required this.masteryLevel,
  });
}

class ChangeFavoriteAchievementEvent extends AchievementEvent {
  final List<AchievementGroup> achievementGroups;
  final DailyGroup dialies;
  final DailyGroup dialiesTomorrow;
  final List<Achievement> achievements;
  final List<Achievement> favoriteAchievements;
  final List<Mastery> masteries;
  final bool includeProgress;
  final int achievementPoints;
  final int masteryLevel;

  final int addAchievementId;
  final int removeAchievementId;

  ChangeFavoriteAchievementEvent({
    @required this.achievementGroups,
    @required this.dialies,
    @required this.dialiesTomorrow,
    @required this.achievements,
    @required this.favoriteAchievements,
    @required this.masteries,
    @required this.includeProgress,
    @required this.achievementPoints,
    @required this.masteryLevel,
    this.addAchievementId,
    this.removeAchievementId,
  });
}