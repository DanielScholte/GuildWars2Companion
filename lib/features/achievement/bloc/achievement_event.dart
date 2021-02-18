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
  final int achievementId;

  LoadAchievementDetailsEvent({
    @required this.achievementId,
  });
}

class RefreshAchievementProgressEvent extends AchievementEvent {
  final int achievementId;

  RefreshAchievementProgressEvent({
    @required this.achievementId,
  });
}

class ChangeFavoriteAchievementEvent extends AchievementEvent {
  final int addAchievementId;
  final int removeAchievementId;

  ChangeFavoriteAchievementEvent({
    this.addAchievementId,
    this.removeAchievementId,
  });
}