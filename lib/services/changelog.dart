import 'package:guildwars2_companion/models/other/changelog.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangelogService {
  int lastLaunchBuildNumber = 0;
  int currentBuildNumber = 0;
  List<Changelog> changelog = [
    Changelog(
      version: '1.2.0',
      build: 8,
      newFeatures: true,
      changes: [
        "Dark theme",
        "Language configuration",
      ],
    ),
    Changelog(
      version: '1.1.0',
      build: 5,
      newFeatures: true,
      changes: [
        "The new PvP section",
      ],
    ),
    Changelog(
      version: '1.0.3',
      build: 3,
      changes: [
        "Bug fixes",
      ],
    ),
    Changelog(
      version: '1.0.0',
      build: 1,
      changes: [
        "Initial release",
      ],
    ),
  ];

  Future<void> loadChangelogData() async {
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

  bool anyNewChanges() {
    return 
      currentBuildNumber > lastLaunchBuildNumber &&
      changelog.any((c) => c.build > lastLaunchBuildNumber && c.newFeatures) &&
      (lastLaunchBuildNumber != 0 || DateTime.now().isBefore(DateTime.utc(2020, 3, 6)));
  }

  List<String> getNewFeatures() {
    return changelog.where((c) => c.newFeatures).map((c) => c.changes).expand((i) => i).take(10).toList();
  }
}