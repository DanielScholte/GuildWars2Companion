class Currency {
  int id;
  String name;
  String description;
  int order;
  String icon;
  int value;

  Currency({this.id, this.name, this.description, this.order, this.icon, this.value});

  Currency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    order = json['order'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['order'] = this.order;
    data['icon'] = this.icon;
    return data;
  }
}