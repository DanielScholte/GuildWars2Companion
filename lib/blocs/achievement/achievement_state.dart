import 'package:guildwars2_companion/models/achievement/achievement_group.dart';
import 'package:guildwars2_companion/models/achievement/daily.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AchievementState {}
  
class LoadingAchievementsState extends AchievementState {}

class LoadedAchievementsState extends AchievementState {
  final List<AchievementGroup> achievementGroups;
  final DailyGroup dailyGroup;

  LoadedAchievementsState({
    @required this.achievementGroups,
    @required this.dailyGroup
  });
}