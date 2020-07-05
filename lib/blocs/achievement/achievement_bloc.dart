import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/models/achievement/achievement_data.dart';
import 'package:guildwars2_companion/models/mastery/mastery_data.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import './bloc.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {

  final AchievementRepository achievementRepository;

  AchievementBloc({
    @required this.achievementRepository,
  }): super(LoadingAchievementsState());

  @override
  Stream<AchievementState> mapEventToState(
    AchievementEvent event,
  ) async* {
    if (event is LoadAchievementsEvent) {
      yield* _loadAchievements(event.includeProgress);
    } else if (event is LoadAchievementDetailsEvent) {
      yield* _loadAchievementDetails(event);
    } else if (event is RefreshAchievementProgressEvent) {
      yield* _refreshAchievementProgress(event);
    } else if (event is ChangeFavoriteAchievementEvent) {
      yield* _changeFavoriteAchievement(event);
    }
  }

  Stream<AchievementState> _loadAchievements(bool includeProgress) async* {
    try {
      yield LoadingAchievementsState();

      AchievementData achievementData = await achievementRepository.getAchievements(includeProgress);
      MasteryData masteryData = await achievementRepository.getMasteries(includeProgress);

      yield LoadedAchievementsState(
        achievementGroups: achievementData.achievementGroups,
        dailies: achievementData.dailies,
        masteries: masteryData.masteries,
        dailiesTomorrow: achievementData.dailiesTomorrow,
        achievements: achievementData.achievements,
        favoriteAchievements: achievementData.favoriteAchievements,
        includesProgress: includeProgress,
        achievementPoints: achievementData.achievementPoints,
        masteryLevel: masteryData.masteryLevel,
      );
    } catch (_) {
      yield ErrorAchievementsState(includeProgress);
    }
  }

  Stream<AchievementState> _loadAchievementDetails(LoadAchievementDetailsEvent event) async* {
    try {
      Achievement achievement = event.achievements.firstWhere((a) => a.id == event.achievementId);
      achievement.loading = true;

      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: event.favoriteAchievements,
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
      );

      await achievementRepository.loadAchievementDetails(achievement, event.achievements);

      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: event.favoriteAchievements,
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
      );
    } catch (_) {
      Achievement achievement = event.achievements.firstWhere((a) => a.id == event.achievementId, orElse: () => null);

      if (achievement != null) {
        achievement.loading = false;
        achievement.loaded = false;
      }

      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: event.favoriteAchievements,
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
        hasError: true
      );
    }
  }

  Stream<AchievementState> _refreshAchievementProgress(RefreshAchievementProgressEvent event) async* {
    try {
      Achievement achievement = event.achievements.firstWhere((a) => a.id == event.achievementId);
      achievement.loading = true;

      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: event.favoriteAchievements,
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
      );

      await achievementRepository.updateAchievementProgress(achievement);

      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: event.favoriteAchievements,
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
      );
    } catch (_) {
      Achievement achievement = event.achievements.firstWhere((a) => a.id == event.achievementId, orElse: () => null);

      if (achievement != null) {
        achievement.loading = false;
      }

      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: event.favoriteAchievements,
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
        hasError: true
      );
    }
  }

  Stream<AchievementState> _changeFavoriteAchievement(ChangeFavoriteAchievementEvent event) async* {
    try {
      if (event.addAchievementId != null) {
        await achievementRepository.setFavoriteAchievement(event.addAchievementId);
      }

      if (event.removeAchievementId != null) {
        await achievementRepository.removeFavoriteAchievement(event.removeAchievementId);
      }

      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: await achievementRepository.getFavoriteAchievements(event.achievements),
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
      );
    } catch (_) {
      yield LoadedAchievementsState(
        achievementGroups: event.achievementGroups,
        dailies: event.dialies,
        dailiesTomorrow: event.dialiesTomorrow,
        achievements: event.achievements,
        favoriteAchievements: event.favoriteAchievements,
        masteries: event.masteries,
        includesProgress: event.includeProgress,
        achievementPoints: event.achievementPoints,
        masteryLevel: event.masteryLevel,
        hasError: true
      );
    }
  }
}
