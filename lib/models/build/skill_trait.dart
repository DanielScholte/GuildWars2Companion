import 'dart:convert';

class SkillTrait {
  String name;
  List<Fact> facts;
  String description;
  String icon;
  String type;
  String slot;
  int id;
  int tier;
  String chatLink;
  List<Fact> traitedFacts;

  SkillTrait(
      {this.name,
      this.facts,
      this.description,
      this.icon,
      this.type,
      this.slot,
      this.id,
      this.chatLink,
      this.traitedFacts});

  SkillTrait.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    type = json['type'];
    tier = json['tier'];
    slot = json['slot'];
    id = json['id'];
    chatLink = json['chat_link'];

    if (json['facts'] != null) {
      facts = new List<Fact>();
      json['facts'].forEach((v) {
        facts.add(new Fact.fromJson(v));
      });
    }

    if (json['traited_facts'] != null) {
      traitedFacts = new List<Fact>();
      json['traited_facts'].forEach((v) {
        traitedFacts.add(new Fact.fromJson(v));
      });
    }
  }

  SkillTrait.fromDb(Map<String, dynamic> data) {
    name = data['name'];
    description = data['description'];
    icon = data['icon'];
    type = data['type'];
    slot = data['slot'];
    id = data['id'];
    chatLink = data['chatLink'];

    if (data['facts'] != null) {
      List factsMap = json.decode(data['facts']);
      facts = factsMap.map((b) => Fact.fromJson(b)).toList();
    }

    if (data['traited_facts'] != null) {
      List traitedFactsMap = json.decode(data['traitedFacts']);
      traitedFacts = traitedFactsMap.map((b) => Fact.fromJson(b)).toList();
    }
  }

  Map<String, dynamic> toDb(String expirationDate) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type;
    data['slot'] = this.slot;
    data['chatLink'] = this.chatLink;
    data['expiration_date'] = expirationDate;

    if (this.facts != null && this.facts.isNotEmpty) {
      data['facts'] = json.encode(this.facts.map((b) => b.toJson()).toList());
    }

    if (this.traitedFacts != null && this.traitedFacts.isNotEmpty) {
      data['traitedFacts'] = json.encode(this.traitedFacts.map((t) => t.toJson()).toList());
    }
    
    return data;
  }
}

class Fact {
  String text;
  String type;
  String icon;
  int value;
  int duration;
  int hitCount;
  double dmgMultiplier;
  String status;
  String description;
  int applyCount;
  int distance;

  Fact(
      {this.text,
      this.type,
      this.icon,
      this.value,
      this.duration,
      this.hitCount,
      this.dmgMultiplier,
      this.status,
      this.description,
      this.applyCount,
      this.distance});

  Fact.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
    icon = json['icon'];
    value = json['value'];
    duration = json['duration'];
    hitCount = json['hit_count'];
    dmgMultiplier = json['dmg_multiplier'];
    status = json['status'];
    description = json['description'];
    applyCount = json['apply_count'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['type'] = this.type;
    data['icon'] = this.icon;
    data['value'] = this.value;
    data['duration'] = this.duration;
    data['hit_count'] = this.hitCount;
    data['dmg_multiplier'] = this.dmgMultiplier;
    data['status'] = this.status;
    data['description'] = this.description;
    data['apply_count'] = this.applyCount;
    data['distance'] = this.distance;
    return data;
  }
}