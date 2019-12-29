import 'package:guildwars2_companion/models/items/item.dart';
import 'package:guildwars2_companion/models/items/skin.dart';

class InventoryItem {
	int id;
	int count;
  int skin;
	String binding;
	int charges;
  Item itemInfo;
  Skin skinInfo;

	InventoryItem({this.id, this.count, this.binding, this.charges, this.skin});

	InventoryItem.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      id = -1;
      return;
    }
		id = json['id'];
		count = json['count'];
		binding = json['binding'];
		charges = json['charges'];
    skin = json['skin'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['count'] = this.count;
		data['binding'] = this.binding;
		data['charges'] = this.charges;
    data['skin'] = this.skin;
		return data;
	}
}