class Skin {
  String name;
  String type;
  String rarity;
  int id;
  String icon;

  Skin({this.name, this.type, this.rarity, this.id, this.icon});

  Skin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    rarity = json['rarity'];
    id = json['id'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['rarity'] = this.rarity;
    data['id'] = this.id;
    data['icon'] = this.icon;
    return data;
  }
}