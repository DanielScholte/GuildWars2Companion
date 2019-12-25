import 'bags.dart';
import 'crafting.dart';
import 'equipment.dart';

class Character {
	String name;
	String race;
	String gender;
	String profession;
	int level;
	String guild;
	int age;
	String created;
	int deaths;
	List<Crafting> crafting;
	int title;
  String titleName;
	List<Equipment> equipment;
	List<Bags> bags;

	Character({this.name, this.race, this.gender, this.profession, this.level, this.guild, this.age, this.created, this.deaths, this.crafting, this.title, this.equipment, this.bags});

	Character.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		race = json['race'];
		gender = json['gender'];
		profession = json['profession'];
		level = json['level'];
		guild = json['guild'];
		age = json['age'];
		created = json['created'];
		deaths = json['deaths'];
		if (json['crafting'] != null) {
			crafting = new List<Crafting>();
			json['crafting'].forEach((v) { crafting.add(new Crafting.fromJson(v)); });
		}
		title = json['title'];
		if (json['equipment'] != null) {
			equipment = new List<Equipment>();
			json['equipment'].forEach((v) { equipment.add(new Equipment.fromJson(v)); });
		}
		if (json['bags'] != null) {
			bags = new List<Bags>();
			json['bags'].forEach((v) { bags.add(new Bags.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['race'] = this.race;
		data['gender'] = this.gender;
		data['profession'] = this.profession;
		data['level'] = this.level;
		data['guild'] = this.guild;
		data['age'] = this.age;
		data['created'] = this.created;
		data['deaths'] = this.deaths;
		if (this.crafting != null) {
      data['crafting'] = this.crafting.map((v) => v.toJson()).toList();
    }
		data['title'] = this.title;
		if (this.equipment != null) {
      data['equipment'] = this.equipment.map((v) => v.toJson()).toList();
    }
		if (this.bags != null) {
      data['bags'] = this.bags.map((v) => v.toJson()).toList();
    }
		return data;
	}
}