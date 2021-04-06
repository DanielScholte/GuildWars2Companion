class PvpRank {
  int id;
  int finisherId;
  String name;
  String icon;
  int minRank;
  int maxRank;
  List<PvpRankLevels> levels;

  PvpRank(
      {this.id,
      this.finisherId,
      this.name,
      this.icon,
      this.minRank,
      this.maxRank,
      this.levels});

  PvpRank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    finisherId = json['finisher_id'];
    name = json['name'];
    icon = json['icon'];
    minRank = json['min_rank'];
    maxRank = json['max_rank'];
    if (json['levels'] != null) {
      levels = (json['levels'] as List)
        .map((j) => PvpRankLevels.fromJson(j))
        .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['finisher_id'] = this.finisherId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['min_rank'] = this.minRank;
    data['max_rank'] = this.maxRank;
    if (this.levels != null) {
      data['levels'] = this.levels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PvpRankLevels {
  int minRank;
  int maxRank;
  int points;

  PvpRankLevels({this.minRank, this.maxRank, this.points});

  PvpRankLevels.fromJson(Map<String, dynamic> json) {
    minRank = json['min_rank'];
    maxRank = json['max_rank'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_rank'] = this.minRank;
    data['max_rank'] = this.maxRank;
    data['points'] = this.points;
    return data;
  }
}