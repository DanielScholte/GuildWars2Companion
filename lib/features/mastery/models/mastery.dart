class Mastery {
  int id;
  String name;
  String requirement;
  int order;
  String background;
  String region;
  List<MasteryLevel> levels;
  int level;

  Mastery(
      {this.id,
      this.name,
      this.requirement,
      this.order,
      this.background,
      this.region,
      this.levels});

  Mastery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    requirement = json['requirement'];
    order = json['order'];
    background = json['background'];
    region = json['region'];
    if (json['levels'] != null) {
      levels = (json['levels'] as List)
        .map((j) => MasteryLevel.fromJson(j))
        .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['requirement'] = this.requirement;
    data['order'] = this.order;
    data['background'] = this.background;
    data['region'] = this.region;
    if (this.levels != null) {
      data['levels'] = this.levels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MasteryLevel {
  String name;
  String description;
  String instruction;
  String icon;
  int pointCost;
  int expCost;
  bool done;
  String region;

  MasteryLevel(
      {this.name,
      this.description,
      this.instruction,
      this.icon,
      this.pointCost,
      this.expCost});

  MasteryLevel.fromJson(Map<String, dynamic> json) {
    done = false;
    name = json['name'];
    description = json['description'];
    instruction = json['instruction'];
    icon = json['icon'];
    pointCost = json['point_cost'];
    expCost = json['exp_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['instruction'] = this.instruction;
    data['icon'] = this.icon;
    data['point_cost'] = this.pointCost;
    data['exp_cost'] = this.expCost;
    return data;
  }
}