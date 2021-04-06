class MasteryProgress {
  int id;
  int level;

  MasteryProgress({this.id, this.level});

  MasteryProgress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['level'] = this.level;
    return data;
  }
}