class AccountTitle {
  int id;
  String name;
  int achievement;
  List<int> achievements;

  AccountTitle({this.id, this.name, this.achievement, this.achievements});

  AccountTitle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    achievement = json['achievement'];
    if (json.containsKey('achievements')) {
      achievements = json['achievements'].cast<int>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['achievement'] = this.achievement;
    data['achievements'] = this.achievements;
    return data;
  }
}