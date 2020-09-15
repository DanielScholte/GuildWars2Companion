import 'package:guildwars2_companion/models/items/item_details.dart';

class Item {
  String name;
  String description;
  String type;
  int level;
  String rarity;
  int vendorValue;
  int id;
  String icon;
  ItemDetails details;
  List<String> flags;

  Item(
    {this.name,
      this.description,
      this.type,
      this.level,
      this.rarity,
      this.vendorValue,
      this.id,
      this.icon,
      this.details,
      this.flags});

  Item.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    type = json['type'];
    level = json['level'];
    rarity = json['rarity'];
    vendorValue = json['vendor_value'];
    id = json['id'];
    icon = json['icon'];
    details =
        json['details'] != null ? new ItemDetails.fromJson(json['details']) : ItemDetails();
    if (json['flags'] != null) {
      this.flags = json['flags'].cast<String>();
    }
  }

  Item.fromDb(Map<String, dynamic> item) {
    id =  item['id'];
    name = item['name'];
    description = item['description'];
    type = item['type'];
    rarity = item['rarity'];
    icon = item['icon'];
    level = item['level'];
    vendorValue = item['vendorValue'];
    details = ItemDetails(
      type: item['details_type'],
      weightClass: item['details_weightClass'],
      unlockType : item['details_unlockType'],
      name : item['details_name'],
      description: item['details_description'],
      defense : item['details_defense'],
      size : item['details_size'],
      durationMs : item['details_durationMs'],
      charges : item['details_charges'],
      minPower : item['details_minPower'],
      maxPower : item['details_maxPower'],
    );
    flags = item['flags'].split(';');
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
    data['icon'] = this.icon;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    if (this.flags != null) {
      data['flags'] = this.flags.join(';');
    }
    return data;
  }

  Map<String, dynamic> toDb(String expirationDate) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['level'] = this.level;
    data['rarity'] = this.rarity;
    data['vendorValue'] = this.vendorValue;
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['expiration_date'] = expirationDate;
    if (this.details != null) {
      data['details_type'] = details.type;
      data['details_weightClass'] = details.weightClass;
      data['details_unlockType'] = details.unlockType;
      data['details_name'] = details.name;
      data['details_description'] = details.description;
      data['details_defense'] = details.defense;
      data['details_size'] = details.size;
      data['details_durationMs'] = details.durationMs;
      data['details_charges'] = details.charges;
      data['details_minPower'] = details.minPower;
      data['details_maxPower'] = details.maxPower;
    } else {
      data['details_type'] = null;
      data['details_weightClass'] = null;
      data['details_unlockType'] = null;
      data['details_name'] = null;
      data['details_description'] = null;
      data['details_defense'] = null;
      data['details_size'] = null;
      data['details_durationMs'] = null;
      data['details_charges'] = null;
      data['details_minPower'] = null;
      data['details_maxPower'] = null;
    }
    if (this.flags != null) {
      data['flags'] = flags.join(';');
    }
    return data;
  }
}