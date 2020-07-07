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
    if (json['facts'] != null) {
      facts = new List<Fact>();
      json['facts'].forEach((v) {
        facts.add(new Fact.fromJson(v));
      });
    }
    description = json['description'];
    icon = json['icon'];
    type = json['type'];
    slot = json['slot'];
    id = json['id'];
    chatLink = json['chat_link'];
    if (json['traited_facts'] != null) {
      traitedFacts = new List<Fact>();
      json['traited_facts'].forEach((v) {
        traitedFacts.add(new Fact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.facts != null) {
      data['facts'] = this.facts.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['type'] = this.type;
    data['slot'] = this.slot;
    data['id'] = this.id;
    data['chat_link'] = this.chatLink;
    if (this.traitedFacts != null) {
      data['traited_facts'] = this.traitedFacts.map((v) => v.toJson()).toList();
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