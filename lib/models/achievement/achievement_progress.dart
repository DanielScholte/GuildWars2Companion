class AchievementProgress {
  int id;
  List<int> bits;
  int current;
  int max;
  int repeated;
  bool done;
  bool unlocked;
  int points;

  AchievementProgress({this.id, this.bits, this.current, this.max, this.done});

  AchievementProgress.fromJson(Map<String, dynamic> json) {
    points = 0;
    id = json['id'];
    if (json['bits'] != null) {
      bits = json['bits'].cast<int>();
    }
    current = json['current'];
    max = json['max'];
    done = json['done'];
    unlocked = json['unlocked'];
    repeated = json['repeated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bits'] = this.bits;
    data['current'] = this.current;
    data['max'] = this.max;
    data['done'] = this.done;
    return data;
  }
}