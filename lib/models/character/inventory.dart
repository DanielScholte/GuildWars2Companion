class Inventory {
	int id;
	int count;
	String binding;
	int charges;

	Inventory({this.id, this.count, this.binding, this.charges});

	Inventory.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      id = -1;
      return;
    }
		id = json['id'];
		count = json['count'];
		binding = json['binding'];
		charges = json['charges'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['count'] = this.count;
		data['binding'] = this.binding;
		data['charges'] = this.charges;
		return data;
	}
}