import 'package:guildwars2_companion/models/pvp/season.dart';

class PvpStanding {
  PvpStandingStats current;
  PvpStandingStats best;
  String seasonId;
  PvpSeason season;

  PvpStanding({this.current, this.best, this.seasonId});

  PvpStanding.fromJson(Map<String, dynamic> json) {
    current =
        json['current'] != null ? new PvpStandingStats.fromJson(json['current']) : null;
    best = json['best'] != null ? new PvpStandingStats.fromJson(json['best']) : null;
    seasonId = json['season_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.current != null) {
      data['current'] = this.current.toJson();
    }
    if (this.best != null) {
      data['best'] = this.best.toJson();
    }
    data['season_id'] = this.seasonId;
    return data;
  }
}

class PvpStandingStats {
  int totalPoints;
  int division;
  int tier;
  int points;
  int repeats;
  int rating;

  PvpStandingStats(
      {this.totalPoints,
      this.division,
      this.tier,
      this.points,
      this.repeats,
      this.rating});

  PvpStandingStats.fromJson(Map<String, dynamic> json) {
    totalPoints = json['total_points'];
    division = json['division'];
    tier = json['tier'];
    points = json['points'];
    repeats = json['repeats'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_points'] = this.totalPoints;
    data['division'] = this.division;
    data['tier'] = this.tier;
    data['points'] = this.points;
    data['repeats'] = this.repeats;
    data['rating'] = this.rating;
    return data;
  }
}
