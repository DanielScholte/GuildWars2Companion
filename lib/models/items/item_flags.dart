class ItemFlags {
  bool AccountBindOnUse = false;
  bool AccountBound = false;
  bool Attuned = false;
  bool BulkConsume = false;
  bool DeleteWarning = false;
  bool HideSuffix = false;
  bool Infused = false;
  bool MonsterOnly = false;
  bool NoMysticForge = false;
  bool NoSalvage = false;
  bool NoSell = false;
  bool NotUpgradeable = false;
  bool NoUnderwater = false;
  bool SoulbindOnAcquire = false;
  bool SoulBindOnUse = false;
  bool Tonic = false;
  bool Unique = false;

  ItemFlags(
      {
        this.AccountBindOnUse,
        this.AccountBound,
        this.Attuned,
        this.BulkConsume,
        this.DeleteWarning,
        this.HideSuffix,
        this.Infused,
        this.MonsterOnly,
        this.NoMysticForge,
        this.NoSalvage,
        this.NoSell,
        this.NotUpgradeable,
        this.NoUnderwater,
        this.SoulbindOnAcquire,
        this.SoulBindOnUse,
        this.Tonic,
        this.Unique
      });

  ItemFlags.fromJson(List<dynamic> json) {

    // Dart in Flutter does not support Reflection
    // So we do this the long way
    json.forEach((key) {
      if (key == "AccountBindOnUse") AccountBindOnUse = true;
      if (key == "AccountBound") AccountBound = true;
      if (key == "Attuned") Attuned = true;
      if (key == "BulkConsume") BulkConsume = true;
      if (key == "DeleteWarning") DeleteWarning = true;
      if (key == "HideSuffix") HideSuffix = true;
      if (key == "Infused") Infused = true;
      if (key == "MonsterOnly") MonsterOnly = true;
      if (key == "NoMysticForge") NoMysticForge = true;
      if (key == "NoSalvage") NoSalvage = true;
      if (key == "NoSell") NoSell = true;
      if (key == "NotUpgradeable") NotUpgradeable = true;
      if (key == "NoUnderwater") NoUnderwater = true;
      if (key == "SoulbindOnAcquire") SoulbindOnAcquire = true;
      if (key == "SoulBindOnUse") SoulBindOnUse = true;
      if (key == "Tonic") Tonic = true;
      if (key == "Inique") Unique = true;

    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flags_AccountBindOnUse'] = this.AccountBindOnUse;
    data['flags_AccountBound'] = this.AccountBound;
    data['flags_Attuned'] = this.Attuned;
    data['flags_BulkConsume'] = this.BulkConsume;
    data['flags_DeleteWarning'] = this.DeleteWarning;
    data['flags_HideSuffix'] = this.HideSuffix;
    data['flags_flags_Infused'] = this.Infused;
    data['flags_MonsterOnly'] = this.MonsterOnly;
    data['flags_NoMysticForge'] = this.NoMysticForge;
    data['flags_NoSalvage'] = this.NoSalvage;
    data['flags_NoSell'] = this.NoSell;
    data['flags_NotUpgradeable'] = this.NotUpgradeable;
    data['flags_NoUnderwater'] = this.NoUnderwater;
    data['flags_SoulbindOnAcquire'] = this.SoulbindOnAcquire;
    data['flags_SoulBindOnUse'] = this.SoulBindOnUse;
    data['flags_Tonic'] = this.Tonic;
    data['flags_Unique'] = this.Unique;
    return data;
  }
}