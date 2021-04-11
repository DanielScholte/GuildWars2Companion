import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/features/changelog/models/changelog.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangelogService {
  List<Changelog> changelog;
  int lastLaunchBuildNumber = 0;
  int currentBuildNumber = 0;

  Future<void> loadChangelogData() async {
    try {
      List changelogData = await Assets.loadDataAsset(Assets.changelog);
      changelog = changelogData
        .map((c) => Changelog.fromJson(c))
        .toList();
    } catch (_) {
      changelog = [];
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastLaunchBuildNumber = prefs.getInt("lastlaunch_buildnumber") ?? 0;

    PackageInfo platformInfo = await PackageInfo.fromPlatform();
    currentBuildNumber = int.tryParse(platformInfo.buildNumber) ?? 0;
  }

  Future<void> saveNewFeaturesSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lastlaunch_buildnumber", currentBuildNumber);
    lastLaunchBuildNumber = currentBuildNumber;
  }

  bool anyNewChanges() =>
      currentBuildNumber > lastLaunchBuildNumber &&
      changelog.any((c) => c.build > lastLaunchBuildNumber && c.newFeatures);

  List<String> getNewFeatures() {
    return changelog
      .where((c) => c.newFeatures && c.build > lastLaunchBuildNumber)
      .map((c) => c.changes)
      .expand((i) => i)
      .take(10)
      .toList();
  }
}