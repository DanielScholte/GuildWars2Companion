import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/models/skin.dart';

class Equipment {
	int id;
	String slot;
	List<int> upgrades;
  List<Item> upgradesInfo;
	String binding;
	List<int> infusions;
  List<Item> infusionsInfo;
  List<int> tabs;
	int skin;
  Item itemInfo;
  Skin skinInfo;

	Equipment({this.id, this.slot, this.upgrades, this.binding, this.infusions, this.skin});

	Equipment.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		slot = json['slot'];
		binding = json['binding'];
    if (json.containsKey('upgrades')) {
      upgrades = json['upgrades'].cast<int>();
    }
    if (json.containsKey('infusions')) {
      infusions = json['infusions'].cast<int>();
    }
    if (json.containsKey('tabs')) {
      tabs = json['tabs'].cast<int>();
    }
		skin = json['skin'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['slot'] = this.slot;
		data['upgrades'] = this.upgrades;
		data['binding'] = this.binding;
		data['infusions'] = this.infusions;
		data['skin'] = this.skin;
		return data;
	}
}