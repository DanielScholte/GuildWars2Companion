import 'package:guildwars2_companion/features/bank/models/material.dart';

class MaterialCategory {
  int id;
  String name;
  List<int> itemsIds;
  List<Material> materials;
  int order;

  MaterialCategory({this.id, this.name, this.itemsIds, this.order});

  MaterialCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    itemsIds = json['items'].cast<int>();
    order = json['order'];
    materials = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['items'] = this.itemsIds;
    data['order'] = this.order;
    return data;
  }
}