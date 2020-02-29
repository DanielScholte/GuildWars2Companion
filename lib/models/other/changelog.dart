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