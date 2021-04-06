import 'package:guildwars2_companion/features/achievement/models/achievement_category.dart';

class AchievementGroup {
  String id;
  String name;
  String description;
  int order;
  List<int> categories;
  List<String> regions;
  List<AchievementCategory> categoriesInfo;

  AchievementGroup(
      {this.id, this.name, this.description, this.order, this.categories});

  AchievementGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    order = json['order'];
    categories = json['categories'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['order'] = this.order;
    data['categories'] = this.categories;
    return data;
  }
}