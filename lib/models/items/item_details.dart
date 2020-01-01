class ItemDetails {
  String type;
  String weightClass;
  int defense;
  int size;
  int durationMs;
  String unlockType;
  String name;
  int charges;
  int minPower;
  int maxPower;

  ItemDetails(
      {this.type,
      this.weightClass,
      this.defense,
      this.size,
      this.durationMs,
      this.unlockType,
      this.name,
      this.charges,
      this.minPower,
      this.maxPower});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    weightClass = json['weight_class'];
    defense = json['defense'];
    size = json['size'];
    durationMs = json['duration_ms'];
    unlockType = json['unlock_type'];
    name = json['name'];
    charges = json['charges'];
    minPower = json['min_power'];
    maxPower = json['max_power'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['weight_class'] = this.weightClass;
    data['defense'] = this.defense;
    data['size'] = this.size;
    data['duration_ms'] = this.durationMs;
    data['unlock_type'] = this.unlockType;
    data['name'] = this.name;
    data['charges'] = this.charges;
    data['min_power'] = this.minPower;
    data['max_power'] = this.maxPower;
    return data;
  }
}