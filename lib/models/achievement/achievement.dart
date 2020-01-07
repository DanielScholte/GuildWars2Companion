import 'package:guildwars2_companion/models/achievement/achievement_progress.dart';

class Achievement {
  int id;
  String icon;
  String name;
  String description;
  String requirement;
  String lockedText;
  List<AchievementBits> bits;
  List<AchievementTiers> tiers;
  List<AchievementRewards> rewards;
  AchievementProgress progress;
  int pointCap;

  Achievement(
      {this.id,
      this.icon,
      this.name,
      this.description,
      this.requirement,
      this.lockedText,
      this.bits,
      this.tiers,
      this.rewards,
      this.pointCap});

  Achievement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
    description = json['description'];
    requirement = json['requirement'];
    lockedText = json['locked_text'];
    if (json['bits'] != null) {
      bits = new List<AchievementBits>();
      json['bits'].forEach((v) {
        bits.add(new AchievementBits.fromJson(v));
      });
    }
    if (json['tiers'] != null) {
      tiers = new List<AchievementTiers>();
      json['tiers'].forEach((v) {
        tiers.add(new AchievementTiers.fromJson(v));
      });
    }
    if (json['rewards'] != null) {
      rewards = new List<AchievementRewards>();
      json['rewards'].forEach((v) {
        rewards.add(new AchievementRewards.fromJson(v));
      });
    }
    pointCap = json['point_cap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['description'] = this.description;
    data['requirement'] = this.requirement;
    data['locked_text'] = this.lockedText;
    if (this.bits != null) {
      data['bits'] = this.bits.map((v) => v.toJson()).toList();
    }
    if (this.tiers != null) {
      data['tiers'] = this.tiers.map((v) => v.toJson()).toList();
    }
    if (this.rewards != null) {
      data['rewards'] = this.rewards.map((v) => v.toJson()).toList();
    }
    data['point_cap'] = this.pointCap;
    return data;
  }
}

class AchievementBits {
  String type;
  int id;

  AchievementBits({this.type, this.id});

  AchievementBits.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class AchievementTiers {
  int count;
  int points;

  AchievementTiers({this.count, this.points});

  AchievementTiers.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['points'] = this.points;
    return data;
  }
}

class AchievementRewards {
  String type;
  int id;
  int count;

  AchievementRewards({this.type, this.id, this.count});

  AchievementRewards.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['count'] = this.count;
    return data;
  }
}