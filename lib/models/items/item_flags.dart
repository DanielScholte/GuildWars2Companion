class ItemFlags {
  bool accountBindOnUse = false;
  bool accountBound = false;
  bool attuned = false;
  bool bulkConsume = false;
  bool deleteWarning = false;
  bool hideSuffix = false;
  bool infused = false;
  bool monsterOnly = false;
  bool noMysticForge = false;
  bool noSalvage = false;
  bool noSell = false;
  bool notUpgradeable = false;
  bool noUnderwater = false;
  bool soulbindOnAcquire = false;
  bool soulBindOnUse = false;
  bool tonic = false;
  bool unique = false;

  ItemFlags(
      {
        this.accountBindOnUse,
        this.accountBound,
        this.attuned,
        this.bulkConsume,
        this.deleteWarning,
        this.hideSuffix,
        this.infused,
        this.monsterOnly,
        this.noMysticForge,
        this.noSalvage,
        this.noSell,
        this.notUpgradeable,
        this.noUnderwater,
        this.soulbindOnAcquire,
        this.soulBindOnUse,
        this.tonic,
        this.unique
      });

  ItemFlags.fromJson(List<dynamic> json) {

    // Dart in Flutter does not support Reflection
    // So we do this the long way
    json.forEach((key) {
      if (key == "AccountBindOnUse") accountBindOnUse = true;
      if (key == "AccountBound") accountBound = true;
      if (key == "Attuned") attuned = true;
      if (key == "BulkConsume") bulkConsume = true;
      if (key == "DeleteWarning") deleteWarning = true;
      if (key == "HideSuffix") hideSuffix = true;
      if (key == "Infused") infused = true;
      if (key == "MonsterOnly") monsterOnly = true;
      if (key == "NoMysticForge") noMysticForge = true;
      if (key == "NoSalvage") noSalvage = true;
      if (key == "NoSell") noSell = true;
      if (key == "NotUpgradeable") notUpgradeable = true;
      if (key == "NoUnderwater") noUnderwater = true;
      if (key == "SoulbindOnAcquire") soulbindOnAcquire = true;
      if (key == "SoulBindOnUse") soulBindOnUse = true;
      if (key == "Tonic") tonic = true;
      if (key == "Inique") unique = true;

    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flags_AccountBindOnUse'] = this.accountBindOnUse;
    data['flags_AccountBound'] = this.accountBound;
    data['flags_Attuned'] = this.attuned;
    data['flags_BulkConsume'] = this.bulkConsume;
    data['flags_DeleteWarning'] = this.deleteWarning;
    data['flags_HideSuffix'] = this.hideSuffix;
    data['flags_flags_Infused'] = this.infused;
    data['flags_MonsterOnly'] = this.monsterOnly;
    data['flags_NoMysticForge'] = this.noMysticForge;
    data['flags_NoSalvage'] = this.noSalvage;
    data['flags_NoSell'] = this.noSell;
    data['flags_NotUpgradeable'] = this.notUpgradeable;
    data['flags_NoUnderwater'] = this.noUnderwater;
    data['flags_SoulbindOnAcquire'] = this.soulbindOnAcquire;
    data['flags_SoulBindOnUse'] = this.soulBindOnUse;
    data['flags_Tonic'] = this.tonic;
    data['flags_Unique'] = this.unique;
    return data;
  }
}