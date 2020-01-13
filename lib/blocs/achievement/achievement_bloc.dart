import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/achievement/achievement.dart';
import 'package:guildwars2_companion/models/achievement/achievement_category.dart';
import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/models/achievement/achievement_progress.dart';
import 'package:guildwars2_companion/models/achievement/daily.dart';
import 'package:guildwars2_companion/models/character/title.dart';
import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';
import 'package:guildwars2_companion/models/other/mini.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import 'package:guildwars2_companion/repositories/character.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import './bloc.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  @override
  AchievementState get initialState => LoadingAchievementsState();

  final AchievementRepository achievementRepository;
  final CharacterRepository characterRepository;
  final ItemRepository itemRepository;

  AchievementBloc({
    @required this.achievementRepository,
    @required this.characterRepository,
    @required this.itemRepository,
  });

  @override
  Stream<AchievementState> mapEventToState(
    AchievementEvent event,
  ) async* {
    if (event is LoadAchievementsEvent) {
      yield* _loadAchievements(event.includeProgress);
    } else if (event is LoadAchievementDetailsEvent) {
      yield* _loadAchievementDetails(event);
    }
  }

  Stream<AchievementState> _loadAchievements(bool includeProgress) async* {
    yield LoadingAchievementsState();

    await achievementRepository.loadCachedData();

    List<AchievementGroup> achievementGroups = await achievementRepository.getAchievementGroups();
    List<AchievementCategory> achievementCategories = await achievementRepository.getAchievementCategories();
    DailyGroup dailyGroup = await achievementRepository.getDailies();

    List<int> achievementIds = [];
    achievementCategories.forEach((c) => achievementIds.addAll(c.achievements));
    dailyGroup.pve.forEach((c) => achievementIds.add(c.id));
    dailyGroup.pvp.forEach((c) => achievementIds.add(c.id));
    dailyGroup.wvw.forEach((c) => achievementIds.add(c.id));
    dailyGroup.fractals.forEach((c) => achievementIds.add(c.id));

    List<Achievement> achievements = await achievementRepository.getAchievements(achievementIds.toSet().toList());

    if (includeProgress) {
      List<AchievementProgress> progress = await achievementRepository.getAchievementProgress();
      achievements.forEach((a) => a.progress = progress.firstWhere((p) => p.id == a.id, orElse: () => null));
    }

    achievementCategories.forEach((c) {
      c.achievementsInfo = [];
      c.regions = [];
      c.achievements.forEach((i) {
        Achievement achievement = achievements.firstWhere((a) => a.id == i);

        if (achievement != null) {
          c.achievementsInfo.add(achievement);
          achievement.categoryName = c.name;

          if (achievement.icon == null) {
            achievement.icon = c.icon;
          }

          if (achievement.rewards != null && (achievement.progress == null || !achievement.progress.done)
            && achievement.rewards.any((r) => r.type == 'Mastery')) {
            c.regions.addAll(achievement.rewards.where((r) => r.type == 'Mastery').map((r) => r.region).toList());
          }
        }
      });
      c.achievementsInfo.sort((a, b) => -_getProgressionRate(a.progress).compareTo(_getProgressionRate(b.progress)));
      c.regions = c.regions.toSet().toList();
    });

    dailyGroup.pve.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailyGroup.pvp.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailyGroup.wvw.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailyGroup.fractals.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));

    achievementGroups.forEach((g) {
      g.categoriesInfo = [];
      g.regions = [];

      g.categories.forEach((c) {
        AchievementCategory category = achievementCategories.firstWhere((ac) => ac.id == c, orElse: () => null);

        if (category != null) {
          g.categoriesInfo.add(category);
          g.regions.addAll(category.regions);
        }
      });

      g.regions = g.regions.toSet().toList();
      g.categoriesInfo.sort((a, b) => a.order.compareTo(b.order));
    });
    achievementGroups.sort((a, b) => a.order.compareTo(b.order));

    yield LoadedAchievementsState(
      achievementGroups: achievementGroups,
      dailyGroup: dailyGroup,
      achievements: achievements,
      includesProgress: includeProgress
    );
  }

  int _getProgressionRate(AchievementProgress progress) {
    if (progress == null) {
      return 0;
    }

    if (progress.done) {
      return -1;
    }

    if (progress.current == null || progress.max == null) {
      return 0;
    }

    return ((progress.current / progress.max) * 100).round();
  }

  Stream<AchievementState> _loadAchievementDetails(LoadAchievementDetailsEvent event) async* {
    Achievement achievement = event.achievements.firstWhere((a) => a.id == event.achievementId);
    achievement.loading = true;

    yield LoadedAchievementsState(
      achievementGroups: event.achievementGroups,
      dailyGroup: event.dailyGroup,
      achievements: event.achievements,
      includesProgress: event.includeProgress
    );

    if (achievement.prerequisites != null) {
      achievement.prerequisitesInfo = [];
      achievement.prerequisites.forEach((id) {
        Achievement prerequisite = event.achievements.firstWhere((a) => a.id == id, orElse: () => null);

        if (prerequisite != null) {
          achievement.prerequisitesInfo.add(prerequisite);
        }
      });
    }

    List<int> itemIds = [];
    List<int> skinIds = [];
    List<int> miniIds = [];

    if (achievement.bits != null) {
      achievement.bits.forEach((bit) {
        switch (bit.type) {
          case 'Item':
            itemIds.add(bit.id);
            break;
          case 'Skin':
            skinIds.add(bit.id);
            break;
          case 'Minipet':
            miniIds.add(bit.id);
            break;
        }
      });
    }
    
    if (achievement.rewards != null) {
      achievement.rewards.forEach((reward) {
        if (reward.type == 'Item') {
          itemIds.add(reward.id);
        }
      });
    }

    List<Item> items = itemIds.isEmpty ? [] : await itemRepository.getItems(itemIds);
    List<Skin> skins = skinIds.isEmpty ? [] : await itemRepository.getSkins(skinIds);
    List<Mini> minis = miniIds.isEmpty ? [] : await itemRepository.getMinis(miniIds);
    List<AccountTitle> titles = await characterRepository.getTitles();

    if (achievement.bits != null) {
      achievement.bits.forEach((bit) {
        switch (bit.type) {
          case 'Item':
            bit.item = items.firstWhere((i) => i.id == bit.id, orElse: () => null);
            break;
          case 'Skin':
            bit.skin = skins.firstWhere((i) => i.id == bit.id, orElse: () => null);
            break;
          case 'Minipet':
            bit.mini = minis.firstWhere((i) => i.id == bit.id, orElse: () => null);
            break;
        }
      });
    }

    if (achievement.rewards != null) {
      achievement.rewards.forEach((reward) {
        switch (reward.type) {
          case 'Item':
            reward.item = items.firstWhere((i) => i.id == reward.id, orElse: () => null);
            break;
          case 'Title':
            reward.title = titles.firstWhere((i) => i.id == reward.id, orElse: () => null);
            break;
        }
      });
    }

    achievement.loading = false;
    achievement.loaded = true;

    yield LoadedAchievementsState(
      achievementGroups: event.achievementGroups,
      dailyGroup: event.dailyGroup,
      achievements: event.achievements,
      includesProgress: event.includeProgress
    );
  }
}
