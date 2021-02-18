import 'package:guildwars2_companion/features/achievement/models/achievement.dart';

class AchievementCategory {
  int id;
  String name;
  String description;
  int order;
  String icon;
  List<int> achievements;
  List<String> regions;
  List<Achievement> achievementsInfo;
  int completedAchievements;

  AchievementCategory(
      {this.id,
      this.name,
      this.description,
      this.order,
      this.icon,
      this.achievements});

  AchievementCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    order = json['order'];
    icon = json['icon'];
    achievements = json['achievements'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['order'] = this.order;
    data['icon'] = this.icon;
    data['achievements'] = this.achievements;
    return data;
  }
}