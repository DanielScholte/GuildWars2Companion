import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/changelog.dart';
import 'package:guildwars2_companion/services/changelog.dart';

class ChangelogRepository {

  final ChangelogService changelogService;

  ChangelogRepository({
    @required this.changelogService,
  });

  Future<void> saveNewFeaturesSeen() => changelogService.saveNewFeaturesSeen();

  bool anyNewChanges() => changelogService.anyNewChanges();

  ChangelogData getChangelogData() {
    return ChangelogData(
      changelog: changelogService.changelog,
      allChanges: changelogService.getNewFeatures()
    );
  }
}