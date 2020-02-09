class PvpSeason {
  String id;
  String name;
  String start;
  String end;
  bool active;
  List<PvpDivision> divisions;
  List<PvpSeasonRank> ranks;

  PvpSeason(
      {this.id,
      this.name,
      this.start,
      this.end,
      this.active,
      this.divisions,
      this.ranks});

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
    if (json['ranks'] != null) {
      ranks = new List<PvpSeasonRank>();
      json['ranks'].forEach((v) {
        ranks.add(new PvpSeasonRank.fromJson(v));
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
    if (this.ranks != null) {
      data['ranks'] = this.ranks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PvpDivision {
  String name;
  List<String> flags;
  String largeIcon;
  String smallIcon;
  String pipIcon;
  List<PvpDivisionTier> tiers;

  PvpDivision(
      {this.name,
      this.flags,
      this.largeIcon,
      this.smallIcon,
      this.pipIcon,
      this.tiers});

  PvpDivision.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    flags = json['flags'].cast<String>();
    largeIcon = json['large_icon'];
    smallIcon = json['small_icon'];
    pipIcon = json['pip_icon'];
    if (json['tiers'] != null) {
      tiers = new List<PvpDivisionTier>();
      json['tiers'].forEach((v) {
        tiers.add(new PvpDivisionTier.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['flags'] = this.flags;
    data['large_icon'] = this.largeIcon;
    data['small_icon'] = this.smallIcon;
    data['pip_icon'] = this.pipIcon;
    if (this.tiers != null) {
      data['tiers'] = this.tiers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PvpDivisionTier {
  int points;

  PvpDivisionTier({this.points});

  PvpDivisionTier.fromJson(Map<String, dynamic> json) {
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    return data;
  }
}

class PvpSeasonRank {
  String name;
  String description;
  String icon;
  String overlay;
  String overlaySmall;
  List<PvpDivisionTier> tiers;

  PvpSeasonRank(
      {this.name,
      this.description,
      this.icon,
      this.overlay,
      this.overlaySmall,
      this.tiers});

  PvpSeasonRank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    overlay = json['overlay'];
    overlaySmall = json['overlay_small'];
    if (json['tiers'] != null) {
      tiers = new List<PvpDivisionTier>();
      json['tiers'].forEach((v) {
        tiers.add(new PvpDivisionTier.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['overlay'] = this.overlay;
    data['overlay_small'] = this.overlaySmall;
    if (this.tiers != null) {
      data['tiers'] = this.tiers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PvpRankTier {
  int rating;

  PvpRankTier({this.rating});

  PvpRankTier.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    return data;
  }
}
