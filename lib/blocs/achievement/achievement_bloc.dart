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
import 'package:guildwars2_companion/models/mastery/mastery.dart';
import 'package:guildwars2_companion/models/mastery/mastery_progress.dart';
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
    DailyGroup dailies = await achievementRepository.getDailies();
    DailyGroup dailiesTomorrow = await achievementRepository.getDailies(tomorrow: true);
    List<Mastery> masteries = await achievementRepository.getMasteries();

    if (includeProgress) {
      List<MasteryProgress> masteryProgress = await achievementRepository.getMasteryProgress();

      masteries.forEach((mastery) {
        MasteryProgress progress = masteryProgress.firstWhere((m) => m.id == mastery.id, orElse: () => null);

        if (progress != null) {
          mastery.level = progress.level;
          mastery.levels.where((l) => mastery.levels.indexOf(l) <= progress.level).forEach((l) => l.done = true);
        } else {
          mastery.level = 0;
        }
      });
    }

    masteries.sort((a, b) => _getMasteryRate(a).compareTo(_getMasteryRate(b)));

    List<int> achievementIds = [];
    achievementCategories.forEach((c) => achievementIds.addAll(c.achievements));
    dailies.pve.forEach((c) => achievementIds.add(c.id));
    dailies.pvp.forEach((c) => achievementIds.add(c.id));
    dailies.wvw.forEach((c) => achievementIds.add(c.id));
    dailies.fractals.forEach((c) => achievementIds.add(c.id));
    dailiesTomorrow.pve.forEach((c) => achievementIds.add(c.id));
    dailiesTomorrow.pvp.forEach((c) => achievementIds.add(c.id));
    dailiesTomorrow.wvw.forEach((c) => achievementIds.add(c.id));
    dailiesTomorrow.fractals.forEach((c) => achievementIds.add(c.id));

    List<Achievement> achievements = await achievementRepository.getAchievements(achievementIds.toSet().toList());

    int achievementPoints = 0;

    List<AchievementProgress> progress = await achievementRepository.getAchievementProgress();

    achievements.forEach((a) {
      if (includeProgress) {
        a.progress = progress.firstWhere((p) => p.id == a.id, orElse: () => null);
      }
      
      int maxPoints = 0;
      a.tiers.forEach((t) {
        maxPoints += t.points;

        if (a.progress != null) {
          if ((a.progress.current != null && a.progress.current >= t.count) || a.progress.done) {
            a.progress.points += t.points;
          }
        }
      });

      if (a.progress != null && a.progress.repeated != null) {
        a.progress.points += maxPoints * a.progress.repeated;
        if (a.pointCap != null && a.progress.points > a.pointCap) {
          a.progress.points = a.pointCap;
        }
      }

      if (a.pointCap == null) {
        a.pointCap = maxPoints;
      }

      if (a.progress != null) {
        achievementPoints += a.progress.points;
      }
    });

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
      c.achievementsInfo.sort((a, b) => -_getProgressionRate(a, a.progress).compareTo(_getProgressionRate(b, b.progress)));
      c.regions = c.regions.toSet().toList();
    });

    dailies.pve.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailies.pvp.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailies.wvw.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailies.fractals.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailiesTomorrow.pve.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailiesTomorrow.pvp.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailiesTomorrow.wvw.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));
    dailiesTomorrow.fractals.forEach((d) => d.achievementInfo = achievements.firstWhere((a) => a.id == d.id, orElse: () => null));

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
      dailies: dailies,
      masteries: masteries,
      dailiesTomorrow: dailiesTomorrow,
      achievements: achievements,
      includesProgress: includeProgress,
      achievementPoints: achievementPoints,
    );
  }

  int _getProgressionRate(Achievement achievement, AchievementProgress progress) {
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

  int _getMasteryRate(Mastery mastery) {
    int region = 0;

    switch (mastery.region) {
      case 'Desert':
        region = 20;
        break;
      case 'Maguuma':
        region = 10;
        break;
      case 'Tyria':
        break;
      default:
        region = 30;
        break;
    }

    return region + mastery.order;
  }

  Stream<AchievementState> _loadAchievementDetails(LoadAchievementDetailsEvent event) async* {
    Achievement achievement = event.achievements.firstWhere((a) => a.id == event.achievementId);
    achievement.loading = true;

    yield LoadedAchievementsState(
      achievementGroups: event.achievementGroups,
      dailies: event.dialies,
      dailiesTomorrow: event.dialiesTomorrow,
      achievements: event.achievements,
      masteries: event.masteries,
      includesProgress: event.includeProgress,
      achievementPoints: event.achievementPoints
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
      dailies: event.dialies,
      dailiesTomorrow: event.dialiesTomorrow,
      achievements: event.achievements,
      masteries: event.masteries,
      includesProgress: event.includeProgress,
      achievementPoints: event.achievementPoints
    );
  }
}
