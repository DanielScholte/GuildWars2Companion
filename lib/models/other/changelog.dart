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
}

class ChangelogData {
  List<Changelog> changelog;
  List<String> allChanges;

  ChangelogData({
    this.changelog,
    this.allChanges
  });
}