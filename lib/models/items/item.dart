import 'package:guildwars2_companion/models/items/item_details.dart';
import 'package:guildwars2_companion/models/items/item_flags.dart';

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
  ItemFlags flags;

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
    flags = json['flags'] != null ? new ItemFlags.fromJson(json['flags']) : ItemFlags();
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
    flags = ItemFlags(
      accountBindOnUse: item['flags_AccountBindOnUse'] == 1 ? true : false,
      accountBound: item['flags_AccountBound'] == 1 ? true : false,
      attuned: item['flags_Attuned'] == 1 ? true : false,
      bulkConsume: item['flags_BulkConsume'] == 1 ? true : false,
      deleteWarning: item['flags_DeleteWarning'] == 1 ? true : false,
      hideSuffix: item['flags_HideSuffix'] == 1 ? true : false,
      infused: item['flags_Infused'] == 1 ? true : false,
      monsterOnly: item['flags_MonsterOnly'] == 1 ? true : false,
      noMysticForge: item['flags_NoMysticForge'] == 1 ? true : false,
      noSalvage: item['flags_NoSalvage'] == 1 ? true : false,
      noSell: item['flags_NoSell'] == 1 ? true : false,
      notUpgradeable: item['flags_NotUpgradeable'] == 1 ? true : false,
      noUnderwater: item['flags_NoUnderwater'] == 1 ? true : false,
      soulbindOnAcquire: item['flags_SouldBindOnAcquire'] == 1 ? true : false,
      soulBindOnUse: item['flags_SoulBindOnUse'] == 1 ? true : false,
      tonic: item['flags_Tonic'] == 1 ? true : false,
      unique: item['flags_Unique'] == 1 ? true : false,
    );
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
      data['flags_AccountBindOnUse'] = flags.accountBindOnUse ? 1 : 0;
      data['flags_AccountBindOnUse'] = flags.accountBound ? 1 : 0;
      data['flags_Attuned'] = flags.attuned ? 1 : 0;
      data['flags_BulkConsume'] = flags.bulkConsume ? 1 : 0;
      data['flags_DeleteWarning'] = flags.deleteWarning ? 1 : 0;
      data['flags_HideSuffix'] = flags.hideSuffix ? 1 : 0;
      data['flags_Infused'] = flags.infused ? 1 : 0;
      data['flags_MonsterOnly'] = flags.monsterOnly ? 1 : 0;
      data['flags_NoMysticForge'] = flags.noMysticForge ? 1 : 0;
      data['flags_NoSalvage'] = flags.noSalvage ? 1 : 0;
      data['flags_NoSell'] = flags.noSell ? 1 : 0;
      data['flags_NotUpgradeable'] = flags.notUpgradeable ? 1 : 0;
      data['flags_NoUnderwater'] = flags.noUnderwater ? 1 : 0;
      data['flags_SoulbindOnAcquire'] = flags.soulbindOnAcquire ? 1 : 0;
      data['flags_SoulBindOnUse'] = flags.soulBindOnUse ? 1 : 0;
      data['flags_Tonic'] = flags.tonic ? 1 : 0;
      data['flags_Unique'] = flags.unique ? 1 : 0;
    } else {
      data['flags_AccountBindOnUse'] = 0;
      data['flags_AccountBound'] = 0;
      data['flags_Attuned'] = 0;
      data['flags_BulkConsume'] = 0;
      data['flags_DeleteWarning'] = 0;
      data['flags_HideSuffix'] = 0;
      data['flags_Infused'] = 0;
      data['flags_MonsterOnly'] = 0;
      data['flags_NoMysticForge'] = 0;
      data['flags_NoSalvage'] = 0;
      data['flags_NoSell'] = 0;
      data['flags_NotUpgradeable'] = 0;
      data['flags_NoUnderwster'] = 0;
      data['flags_SoulbindOnAcquire'] = 0;
      data['flags_SoulBinOnUse'] = 0;
      data['flags_Tonic'] = 0;
      data['flags_Unique'] = 0;
    }
    return data;
  }
}