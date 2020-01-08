import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/models/achievement/daily.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import './bloc.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  @override
  AchievementState get initialState => LoadingAchievementsState();

  final AchievementRepository achievementRepository;

  AchievementBloc({
    @required this.achievementRepository
  });

  @override
  Stream<AchievementState> mapEventToState(
    AchievementEvent event,
  ) async* {
    if (event is LoadAchievementsEvent) {
      yield* _loadAchievements();
    }
  }

  Stream<AchievementState> _loadAchievements() async* {
    yield LoadingAchievementsState();

    List<AchievementGroup> achievementGroups = await achievementRepository.getAchievementGroups();
    List<AchievementCategory> achievementCategories = await achievementRepository.getAchievementCategories();
    DailyGroup dailyGroups = await achievementRepository.getDailies();

    List<int> achievementIds = [];
    achievementCategories.forEach((c) => achievementIds.addAll(c.achievements));
    dailyGroups.pve.forEach((c) => achievementIds.add(c.id));
    dailyGroups.pvp.forEach((c) => achievementIds.add(c.id));
    dailyGroups.wvw.forEach((c) => achievementIds.add(c.id));
    dailyGroups.fractals.forEach((c) => achievementIds.add(c.id));

    List<Achievement> achievements = await achievementRepository.getAchievements(achievementIds.toSet().toList());

    achievementCategories.forEach((c) {
      c.achievementsInfo = [];
      c.achievements.forEach((i) {
        Achievement achievement = achievements.firstWhere((a) => a.id == i);

        if (achievement != null) {
          c.achievementsInfo.add(achievement);
        }
      });
    });

    dailyGroups.pve.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailyGroups.pvp.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailyGroups.wvw.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailyGroups.fractals.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));

    achievementGroups.forEach((g) {
      g.categoriesInfo = [];

      g.categories.forEach((c) {
        AchievementCategory category = achievementCategories.firstWhere((ac) => ac.id == c, orElse: () => null);

        if (category != null) {
          g.categoriesInfo.add(category);
        }
      });

      g.categoriesInfo.sort((a, b) => a.order.compareTo(b.order));
    });
    achievementGroups.sort((a, b) => a.order.compareTo(b.order));

    yield LoadedAchievementsState(
      achievementGroups: achievementGroups,
      dailyGroup: dailyGroups
    );
  }
}
