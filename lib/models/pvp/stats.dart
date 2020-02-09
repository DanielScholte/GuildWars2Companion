class PvpStats {
  int pvpRank;
  int pvpRankPoints;
  int pvpRankRollovers;
  PvpWinLoss aggregate;
  PvpProfessions professions;
  PvpLadders ladders;

  PvpStats(
      {this.pvpRank,
      this.pvpRankPoints,
      this.pvpRankRollovers,
      this.aggregate,
      this.professions,
      this.ladders});

  PvpStats.fromJson(Map<String, dynamic> json) {
    pvpRank = json['pvp_rank'];
    pvpRankPoints = json['pvp_rank_points'];
    pvpRankRollovers = json['pvp_rank_rollovers'];
    aggregate = json['aggregate'] != null
        ? new PvpWinLoss.fromJson(json['aggregate'])
        : null;
    professions = json['professions'] != null
        ? new PvpProfessions.fromJson(json['professions'])
        : null;
    ladders =
        json['ladders'] != null ? new PvpLadders.fromJson(json['ladders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pvp_rank'] = this.pvpRank;
    data['pvp_rank_points'] = this.pvpRankPoints;
    data['pvp_rank_rollovers'] = this.pvpRankRollovers;
    if (this.aggregate != null) {
      data['aggregate'] = this.aggregate.toJson();
    }
    if (this.professions != null) {
      data['professions'] = this.professions.toJson();
    }
    if (this.ladders != null) {
      data['ladders'] = this.ladders.toJson();
    }
    return data;
  }
}

class PvpWinLoss {
  int wins;
  int losses;
  int desertions;
  int byes;
  int forfeits;

  PvpWinLoss(
      {this.wins, this.losses, this.desertions, this.byes, this.forfeits});

  PvpWinLoss.fromJson(Map<String, dynamic> json) {
    wins = json['wins'];
    losses = json['losses'];
    desertions = json['desertions'];
    byes = json['byes'];
    forfeits = json['forfeits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['desertions'] = this.desertions;
    data['byes'] = this.byes;
    data['forfeits'] = this.forfeits;
    return data;
  }
}

class PvpProfessions {
  PvpWinLoss elementalist;
  PvpWinLoss guardian;
  PvpWinLoss mesmer;
  PvpWinLoss revenant;
  PvpWinLoss thief;
  PvpWinLoss warrior;
  PvpWinLoss necromancer;
  PvpWinLoss engineer;
  PvpWinLoss ranger;

  PvpProfessions(
      {this.elementalist,
      this.guardian,
      this.mesmer,
      this.revenant,
      this.thief,
      this.warrior,
      this.necromancer,
      this.engineer,
      this.ranger});

  PvpProfessions.fromJson(Map<String, dynamic> json) {
    elementalist = json['elementalist'] != null
        ? new PvpWinLoss.fromJson(json['elementalist'])
        : null;
    guardian = json['guardian'] != null
        ? new PvpWinLoss.fromJson(json['guardian'])
        : null;
    mesmer =
        json['mesmer'] != null ? new PvpWinLoss.fromJson(json['mesmer']) : null;
    revenant = json['revenant'] != null
        ? new PvpWinLoss.fromJson(json['revenant'])
        : null;
    thief =
        json['thief'] != null ? new PvpWinLoss.fromJson(json['thief']) : null;
    warrior = json['warrior'] != null
        ? new PvpWinLoss.fromJson(json['warrior'])
        : null;
    necromancer = json['necromancer'] != null
        ? new PvpWinLoss.fromJson(json['necromancer'])
        : null;
    engineer = json['engineer'] != null
        ? new PvpWinLoss.fromJson(json['engineer'])
        : null;
    ranger = json['ranger'] != null
        ? new PvpWinLoss.fromJson(json['ranger'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.elementalist != null) {
      data['elementalist'] = this.elementalist.toJson();
    }
    if (this.guardian != null) {
      data['guardian'] = this.guardian.toJson();
    }
    if (this.mesmer != null) {
      data['mesmer'] = this.mesmer.toJson();
    }
    if (this.revenant != null) {
      data['revenant'] = this.revenant.toJson();
    }
    if (this.thief != null) {
      data['thief'] = this.thief.toJson();
    }
    if (this.warrior != null) {
      data['warrior'] = this.warrior.toJson();
    }
    return data;
  }
}

class PvpLadders {
  PvpWinLoss none;
  PvpWinLoss ranked;
  PvpWinLoss soloarenarated;
  PvpWinLoss teamarenarated;
  PvpWinLoss unranked;

  PvpLadders(
      {this.none,
      this.ranked,
      this.soloarenarated,
      this.teamarenarated,
      this.unranked});

  PvpLadders.fromJson(Map<String, dynamic> json) {
    none = json['none'] != null ? new PvpWinLoss.fromJson(json['none']) : null;
    ranked =
        json['ranked'] != null ? new PvpWinLoss.fromJson(json['ranked']) : null;
    soloarenarated = json['soloarenarated'] != null
        ? new PvpWinLoss.fromJson(json['soloarenarated'])
        : null;
    teamarenarated = json['teamarenarated'] != null
        ? new PvpWinLoss.fromJson(json['teamarenarated'])
        : null;
    unranked = json['unranked'] != null
        ? new PvpWinLoss.fromJson(json['unranked'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.none != null) {
      data['none'] = this.none.toJson();
    }
    if (this.ranked != null) {
      data['ranked'] = this.ranked.toJson();
    }
    if (this.soloarenarated != null) {
      data['soloarenarated'] = this.soloarenarated.toJson();
    }
    if (this.teamarenarated != null) {
      data['teamarenarated'] = this.teamarenarated.toJson();
    }
    if (this.unranked != null) {
      data['unranked'] = this.unranked.toJson();
    }
    return data;
  }
}
