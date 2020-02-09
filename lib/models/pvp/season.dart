class PvpSeason {
  String id;
  String name;
  String start;
  String end;
  bool active;
  List<PvpDivision> divisions;

  PvpSeason(
      {this.id, this.name, this.start, this.end, this.active, this.divisions});

  PvpSeason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    start = json['start'];
    end = json['end'];
    active = json['active'];
    if (json['divisions'] != null) {
      divisions = new List<PvpDivision>();
      json['divisions'].forEach((v) {
        divisions.add(new PvpDivision.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['start'] = this.start;
    data['end'] = this.end;
    data['active'] = this.active;
    if (this.divisions != null) {
      data['divisions'] = this.divisions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PvpDivision {
  String name;
  List<String> flags;
  String pipIcon;
  List<PvpTier> tiers;

  PvpDivision({this.name, this.flags, this.pipIcon, this.tiers});

  PvpDivision.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    flags = json['flags'].cast<String>();
    pipIcon = json['pip_icon'];
    if (json['tiers'] != null) {
      tiers = new List<PvpTier>();
      json['tiers'].forEach((v) {
        tiers.add(new PvpTier.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['flags'] = this.flags;
    data['pip_icon'] = this.pipIcon;
    if (this.tiers != null) {
      data['tiers'] = this.tiers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PvpTier {
  int points;

  PvpTier({this.points});

  PvpTier.fromJson(Map<String, dynamic> json) {
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    return data;
  }
}
