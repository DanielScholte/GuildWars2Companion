import 'package:guildwars2_companion/features/item/models/item.dart';

class Material {
  int id;
  int category;
  int count;
  Item itemInfo;

  Material({this.id, this.category, this.count});

  Material.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['count'] = this.count;
    return data;
  }
}