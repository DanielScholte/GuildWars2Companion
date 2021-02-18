class GameMap {
  int id;
  String name;
  int minLevel;
  int maxLevel;
  int defaultFloor;
  String type;
  int regionId;
  String regionName;
  int continentId;
  String continentName;

  GameMap(
      {this.id,
      this.name,
      this.minLevel,
      this.maxLevel,
      this.defaultFloor,
      this.type,
      this.regionId,
      this.regionName,
      this.continentId,
      this.continentName});

  GameMap.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    minLevel = json['min_level'];
    maxLevel = json['max_level'];
    defaultFloor = json['default_floor'];
    type = json['type'];
    regionId = json['region_id'];
    regionName = json['region_name'];
    continentId = json['continent_id'];
    continentName = json['continent_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['min_level'] = this.minLevel;
    data['max_level'] = this.maxLevel;
    data['default_floor'] = this.defaultFloor;
    data['type'] = this.type;
    data['region_id'] = this.regionId;
    data['region_name'] = this.regionName;
    data['continent_id'] = this.continentId;
    data['continent_name'] = this.continentName;
    return data;
  }
}
