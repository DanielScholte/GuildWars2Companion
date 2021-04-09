class Raid {
  String name;
  String id;
  String region;
  List<RaidCheckpoint> checkpoints;

  Raid({
    this.name,
    this.id,
    this.region,
    this.checkpoints,
  });

  Raid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    if (json['checkpoints'] != null) {
      checkpoints = (json['checkpoints'] as List)
        .map((j) => RaidCheckpoint.fromJson(j))
        .toList();
    }
  }
}

class RaidCheckpoint {
  String id;
  String name;
  bool completed;

  RaidCheckpoint({
    this.id,
    this.name,
    this.completed = false,
  });

  RaidCheckpoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    completed = false;
  }
}