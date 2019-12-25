class Equipment {
	int id;
	String slot;
	List<int> upgrades;
	String binding;
	List<int> infusions;
	int skin;

	Equipment({this.id, this.slot, this.upgrades, this.binding, this.infusions, this.skin});

	Equipment.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		slot = json['slot'];
		upgrades = json['upgrades'].cast<int>();
		binding = json['binding'];
		infusions = json['infusions'].cast<int>();
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