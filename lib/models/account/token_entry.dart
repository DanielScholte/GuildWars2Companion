class TokenEntry {
  int id;
  String name;
  String date;
  String token;

  TokenEntry({this.id, this.name, this.date, this.token});

  TokenEntry.fromDb(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    token = json['token'];
  }

  Map<String, dynamic> toDb() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['date'] = this.date;
    data['token'] = this.token;
    return data;
  }
}