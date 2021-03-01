import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement_data.dart';
import 'package:guildwars2_companion/features/achievement/repositories/achievement.dart';
import 'package:guildwars2_companion/features/mastery/models/mastery_data.dart';
import 'package:guildwars2_companion/features/achievement/models/achievement_group.dart';
import 'package:guildwars2_companion/features/achievement/models/daily.dart';
import 'package:guildwars2_companion/features/mastery/models/mastery.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {

  final AchievementRepository achievementRepository;

  AchievementData _achievementData;
  MasteryData _masteryData;
  bool _includeProgress;

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

      _achievementData = await achievementRepository.getAchievements(includeProgress);
      _masteryData = await achievementRepository.getMasteries(includeProgress);
      _includeProgress = includeProgress;

      yield _getLoadedAchievementsState();
    } catch (_) {
      yield ErrorAchievementsState(includeProgress);
    }
  }

  Stream<AchievementState> _loadAchievementDetails(LoadAchievementDetailsEvent event) async* {
    try {
      Achievement achievement = _achievementData.achievements.firstWhere((a) => a.id == event.achievementId);
      achievement.loading = true;

      yield _getLoadedAchievementsState();

      await achievementRepository.loadAchievementDetails(achievement, _achievementData.achievements);

      yield _getLoadedAchievementsState();
    } catch (_) {
      Achievement achievement = _achievementData.achievements.firstWhere((a) => a.id == event.achievementId, orElse: () => null);

      if (achievement != null) {
        achievement.loading = false;
        achievement.loaded = false;
      }

      yield _getLoadedAchievementsState(hasError: true);
    }
  }

  Stream<AchievementState> _refreshAchievementProgress(RefreshAchievementProgressEvent event) async* {
    try {
      Achievement achievement = _achievementData.achievements.firstWhere((a) => a.id == event.achievementId);
      achievement.loading = true;

      yield _getLoadedAchievementsState();

      await achievementRepository.updateAchievementProgress(achievement);

      yield _getLoadedAchievementsState();
    } catch (_) {
      Achievement achievement = _achievementData.achievements.firstWhere((a) => a.id == event.achievementId, orElse: () => null);

      if (achievement != null) {
        achievement.loading = false;
      }

      yield _getLoadedAchievementsState(hasError: true);
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

      _achievementData = AchievementData(
        achievementGroups: _achievementData.achievementGroups,
        achievementPoints: _achievementData.achievementPoints,
        achievements: _achievementData.achievements,
        dailies: _achievementData.dailies,
        dailiesTomorrow: _achievementData.dailiesTomorrow,
        favoriteAchievements: await achievementRepository.getFavoriteAchievements(_achievementData.achievements)
      );

      yield _getLoadedAchievementsState();
    } catch (_) {
      yield _getLoadedAchievementsState(hasError: true);
    }
  }

  LoadedAchievementsState _getLoadedAchievementsState({ bool hasError = false }) {
    return LoadedAchievementsState(
      achievementGroups: _achievementData.achievementGroups,
      dailies: _achievementData.dailies,
      masteries: _masteryData.masteries,
      dailiesTomorrow: _achievementData.dailiesTomorrow,
      achievements: _achievementData.achievements,
      favoriteAchievements: _achievementData.favoriteAchievements,
      includesProgress: _includeProgress,
      achievementPoints: _achievementData.achievementPoints,
      masteryLevel: _masteryData.masteryLevel,
      hasError: hasError
    );
  }
}
