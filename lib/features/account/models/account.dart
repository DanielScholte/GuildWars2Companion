class Account {
  String id;
  String name;
  int age;
  int world;
  List<String> guilds;
  List<String> guildLeader;
  String created;
  List<String> access;
  bool commander;
  int fractalLevel;
  int dailyAp;
  int monthlyAp;
  int wvwRank;

  Account(
      {this.id,
      this.name,
      this.age,
      this.world,
      this.guilds,
      this.guildLeader,
      this.created,
      this.access,
      this.commander,
      this.fractalLevel,
      this.dailyAp,
      this.monthlyAp,
      this.wvwRank});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    world = json['world'];
    guilds = json['guilds'].cast<String>();
    if (json.containsKey('guild_leader')) {
      guildLeader = json['guild_leader'].cast<String>();
    }
    created = json['created'];
    access = json['access'].cast<String>();
    commander = json['commander'];
    fractalLevel = json['fractal_level'];
    dailyAp = json['daily_ap'];
    monthlyAp = json['monthly_ap'];
    wvwRank = json['wvw_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['age'] = this.age;
    data['world'] = this.world;
    data['guilds'] = this.guilds;
    data['guild_leader'] = this.guildLeader;
    data['created'] = this.created;
    data['access'] = this.access;
    data['commander'] = this.commander;
    data['fractal_level'] = this.fractalLevel;
    data['daily_ap'] = this.dailyAp;
    data['monthly_ap'] = this.monthlyAp;
    data['wvw_rank'] = this.wvwRank;
    return data;
  }
}