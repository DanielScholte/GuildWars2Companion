import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/models/items/item.dart';

class Bags {
	int id;
	int size;
	List<InventoryItem> inventory;
  Item itemInfo;

	Bags({this.id, this.size, this.inventory});

	Bags.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		size = json['size'];
		if (json['inventory'] != null) {
			inventory = new List<InventoryItem>();
			json['inventory'].forEach((v) { inventory.add(new InventoryItem.fromJson(v)); });
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