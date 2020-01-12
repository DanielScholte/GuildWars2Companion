class Mini {
  int id;
  String name;
  String icon;
  int order;
  int itemId;

  Mini({this.id, this.name, this.icon, this.order, this.itemId});

  Mini.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    order = json['order'];
    itemId = json['item_id'];
  }

  Mini.fromDb(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    order = json['display_order'];
    itemId = json['itemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['order'] = this.order;
    data['item_id'] = this.itemId;
    return data;
  }
  
  Map<String, dynamic> toDb(String expirationDate) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['display_order'] = this.order;
    data['itemId'] = this.itemId;
    data['expiration_date'] = expirationDate;
    return data;
  }
}