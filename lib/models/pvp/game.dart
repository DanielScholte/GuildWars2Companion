class PvpGame {
  String id;
  int mapId;
  String started;
  String ended;
  String result;
  String team;
  String profession;
  String ratingType;
  int ratingChange;
  String season;
  PvpScores scores;

  PvpGame(
      {this.id,
      this.mapId,
      this.started,
      this.ended,
      this.result,
      this.team,
      this.profession,
      this.ratingType,
      this.ratingChange,
      this.season,
      this.scores});

  PvpGame.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mapId = json['map_id'];
    started = json['started'];
    ended = json['ended'];
    result = json['result'];
    team = json['team'];
    profession = json['profession'];
    ratingType = json['rating_type'];
    ratingChange = json['rating_change'];
    season = json['season'];
    scores =
        json['scores'] != null ? new PvpScores.fromJson(json['scores']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['map_id'] = this.mapId;
    data['started'] = this.started;
    data['ended'] = this.ended;
    data['result'] = this.result;
    data['team'] = this.team;
    data['profession'] = this.profession;
    data['rating_type'] = this.ratingType;
    data['rating_change'] = this.ratingChange;
    data['season'] = this.season;
    if (this.scores != null) {
      data['scores'] = this.scores.toJson();
    }
    return data;
  }
}

class PvpScores {
  int red;
  int blue;

  PvpScores({this.red, this.blue});

  PvpScores.fromJson(Map<String, dynamic> json) {
    red = json['red'];
    blue = json['blue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['red'] = this.red;
    data['blue'] = this.blue;
    return data;
  }
}