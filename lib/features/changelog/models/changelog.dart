class Changelog {
  String version;
  int build;
  bool newFeatures;
  List<String> changes;

  Changelog({
    this.version,
    this.newFeatures = false,
    this.build,
    this.changes,
  });

  Changelog.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    build = json['build'];
    newFeatures = json['newFeatures'];
    changes = json['changes'].cast<String>();
  }
}

class ChangelogData {
  List<Changelog> changelog;
  List<String> allChanges;

  ChangelogData({
    this.changelog,
    this.allChanges
  });
}