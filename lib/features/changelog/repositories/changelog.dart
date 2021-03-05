import 'package:guildwars2_companion/features/changelog/models/changelog.dart';
import 'package:guildwars2_companion/features/changelog/services/changelog.dart';
import 'package:meta/meta.dart';

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