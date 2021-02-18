class Crafting {
	String discipline;
	int rating;
	bool active;

	Crafting({this.discipline, this.rating, this.active});

	Crafting.fromJson(Map<String, dynamic> json) {
		discipline = json['discipline'];
		rating = json['rating'];
		active = json['active'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['discipline'] = this.discipline;
		data['rating'] = this.rating;
		data['active'] = this.active;
		return data;
	}
}