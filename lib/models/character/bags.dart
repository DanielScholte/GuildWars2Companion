import 'inventory.dart';

class Bags {
	int id;
	int size;
	List<Inventory> inventory;

	Bags({this.id, this.size, this.inventory});

	Bags.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		size = json['size'];
		if (json['inventory'] != null) {
			inventory = new List<Inventory>();
			json['inventory'].forEach((v) { inventory.add(new Inventory.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['size'] = this.size;
		if (this.inventory != null) {
      data['inventory'] = this.inventory.map((v) => v.toJson()).toList();
    }
		return data;
	}
}