class Profession {
  String id;
  String name;
  String icon;
  String iconBig;

  Profession(
      {this.id,
      this.name,
      this.icon,
      this.iconBig});

  Profession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    iconBig = json['icon_big'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['icon_big'] = this.iconBig;
    return data;
  }
}