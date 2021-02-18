import 'dart:ui';

import 'package:guildwars2_companion/features/build/models/build.dart';
import 'package:guildwars2_companion/features/character/models/bags.dart';
import 'package:guildwars2_companion/features/character/models/crafting.dart';
import 'package:guildwars2_companion/features/character/models/equipment.dart';
import 'package:guildwars2_companion/features/character/models/profession.dart';

class Character {
	String name;
	String race;
	String gender;
	String profession;
  Profession professionInfo;
  Color professionColor;
	int level;
	String guild;
	int age;
	String created;
	int deaths;
	List<Crafting> crafting;
	int title;
  String titleName;
  List<Equipment> equipment;
  List<BuildTab> buildTabs;
  List<EquipmentTab> equipmentTabs;
	List<Bags> bags;

	Character({this.buildTabs, this.name, this.race, this.gender, this.profession, this.level, this.guild, this.age, this.created, this.deaths, this.crafting, this.title, this.bags});

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
    if (json['build_tabs'] != null) {
			buildTabs = new List<BuildTab>();
			json['build_tabs'].forEach((v) { buildTabs.add(new BuildTab.fromJson(v)); });
		}
    if (json['equipment_tabs'] != null) {
			equipmentTabs = new List<EquipmentTab>();
			json['equipment_tabs'].forEach((v) { equipmentTabs.add(new EquipmentTab.fromJson(v)); });
		}
		title = json['title'];
    if (json['equipment'] != null) {
			equipment = new List<Equipment>();
			json['equipment'].forEach((v) { equipment.add(new Equipment.fromJson(v)); });
		}
		if (json['bags'] != null) {
			bags = new List<Bags>();
			json['bags'].where((b) => b != null).forEach((v) { bags.add(new Bags.fromJson(v)); });
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
		if (this.bags != null) {
      data['bags'] = this.bags.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class EquipmentTab {
	int tab;
	bool isActive;
  String name;
	List<Equipment> equipment;

	EquipmentTab({this.tab, this.isActive, this.name, this.equipment});

	EquipmentTab.fromJson(Map<String, dynamic> json) {
		tab = json['tab'];
		isActive = json['is_active'];
    name = json['name'];
		if (json['equipment'] != null) {
			equipment = new List<Equipment>();
			json['equipment'].forEach((v) { equipment.add(new Equipment.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['tab'] = this.tab;
		data['is_active'] = this.isActive;
		return data;
	}
}

class BuildTab {
	int tab;
	bool isActive;
	Build build;

	BuildTab({this.tab, this.isActive, this.build});

	BuildTab.fromJson(Map<String, dynamic> json) {
		tab = json['tab'];
		isActive = json['is_active'];
		build = json['build'] != null ? new Build.fromJson(json['build']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['tab'] = this.tab;
		data['is_active'] = this.isActive;
		if (this.build != null) {
      data['build'] = this.build.toJson();
    }
		return data;
	}
}