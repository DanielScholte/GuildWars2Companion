class Specialization {
  int id;
  String name;
  String profession;
  bool elite;
  List<int> minorTraits;
  List<int> majorTraits;
  String icon;
  String background;

  Specialization(
      {this.id,
      this.name,
      this.profession,
      this.elite,
      this.minorTraits,
      this.majorTraits,
      this.icon,
      this.background});

  Specialization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profession = json['profession'];
    elite = json['elite'];
    minorTraits = json['minor_traits'].cast<int>();
    majorTraits = json['major_traits'].cast<int>();
    icon = json['icon'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profession'] = this.profession;
    data['elite'] = this.elite;
    data['minor_traits'] = this.minorTraits;
    data['major_traits'] = this.majorTraits;
    data['icon'] = this.icon;
    data['background'] = this.background;
    return data;
  }
}