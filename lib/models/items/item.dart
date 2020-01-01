import 'package:guildwars2_companion/models/items/item_details.dart';

class Item {
  String name;
  String description;
  String type;
  int level;
  String rarity;
  int vendorValue;
  int id;
  String chatLink;
  String icon;
  ItemDetails details;

  Item(
      {this.name,
      this.description,
      this.type,
      this.level,
      this.rarity,
      this.vendorValue,
      this.id,
      this.chatLink,
      this.icon,
      this.details});

  Item.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
    level = json['level'];
    rarity = json['rarity'];
    vendorValue = json['vendor_value'];
    id = json['id'];
    chatLink = json['chat_link'];
    icon = json['icon'];
    details =
        json['details'] != null ? new ItemDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['level'] = this.level;
    data['rarity'] = this.rarity;
    data['vendor_value'] = this.vendorValue;
    data['id'] = this.id;
    data['chat_link'] = this.chatLink;
    data['icon'] = this.icon;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    return data;
  }
}