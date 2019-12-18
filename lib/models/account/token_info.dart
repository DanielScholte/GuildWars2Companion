class TokenInfo {
  String id;
  String name;
  List<String> permissions;

  TokenInfo({this.id, this.name, this.permissions});

  TokenInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    permissions = json['permissions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['permissions'] = this.permissions;
    return data;
  }
}