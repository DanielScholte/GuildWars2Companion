import 'package:guildwars2_companion/features/achievement/models/achievement.dart';

class DailyGroup {
  List<Daily> pve;
  List<Daily> pvp;
  List<Daily> wvw;
  List<Daily> fractals;
  List<Daily> special;

  DailyGroup({this.pve, this.pvp, this.wvw, this.fractals, this.special});

  DailyGroup.fromJson(Map<String, dynamic> json) {
    if (json['pve'] != null) {
      pve = new List<Daily>();
      json['pve'].forEach((v) {
        pve.add(new Daily.fromJson(v));
      });
    } else {
      pve = [];
    }

    if (json['pvp'] != null) {
      pvp = new List<Daily>();
      json['pvp'].forEach((v) {
        pvp.add(new Daily.fromJson(v));
      });
    } else {
      pvp = [];
    }
    if (json['wvw'] != null) {
      wvw = new List<Daily>();
      json['wvw'].forEach((v) {
        wvw.add(new Daily.fromJson(v));
      });
    } else {
      wvw = [];
    }
    if (json['fractals'] != null) {
      fractals = new List<Daily>();
      json['fractals'].forEach((v) {
        fractals.add(new Daily.fromJson(v));
      });
    } else {
      fractals = [];
    }
    if (json['special'] != null) {
      special = new List<Daily>();
      json['special'].forEach((v) {
        special.add(new Daily.fromJson(v));
      });
    } else {
      special = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pve != null) {
      data['pve'] = this.pve.map((v) => v.toJson()).toList();
    }
    if (this.pvp != null) {
      data['pvp'] = this.pvp.map((v) => v.toJson()).toList();
    }
    if (this.wvw != null) {
      data['wvw'] = this.wvw.map((v) => v.toJson()).toList();
    }
    if (this.fractals != null) {
      data['fractals'] = this.fractals.map((v) => v.toJson()).toList();
    }
    if (this.special != null) {
      data['special'] = this.special.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Daily {
  int id;
  Level level;
  List<String> requiredAccess;
  Achievement achievementInfo;

  Daily({this.id, this.level, this.requiredAccess});

  Daily.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'] != null ? new Level.fromJson(json['level']) : null;
    requiredAccess = json['required_access'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.level != null) {
      data['level'] = this.level.toJson();
    }
    data['required_access'] = this.requiredAccess;
    return data;
  }
}

class Level {
  int min;
  int max;

  Level({this.min, this.max});

  Level.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min'] = this.min;
    data['max'] = this.max;
    return data;
  }
}