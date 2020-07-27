import 'package:guildwars2_companion/models/other/changelog.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangelogService {
  int lastLaunchBuildNumber = 0;
  int currentBuildNumber = 0;

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

  List<Changelog> changelog = [
    Changelog(
      version: '1.4.2',
      build: 19,
      newFeatures: false,
      changes: [
        'Fixed an issue where non-legendary gear might not contain any upgrades'
      ],
    ),
    Changelog(
      version: '1.4.1',
      build: 18,
      newFeatures: false,
      changes: [
        'Fixed Dark Theme bugs'
      ],
    ),
    Changelog(
      version: '1.4.0',
      build: 17,
      newFeatures: true,
      changes: [
        'Equipment tabs',
        'Build tabs',
        'Build storage',
        'User interface improvements',
        'Network improvements'
      ],
    ),
    Changelog(
      version: '1.3.1',
      build: 15,
      newFeatures: true,
      changes: [
        'User interface improvements'
      ],
    ),
    Changelog(
      version: '1.3.0',
      build: 13,
      newFeatures: true,
      changes: [
        'Favorite achievements',
        'Achievement category progression'
      ],
    ),
    Changelog(
      version: '1.2.1',
      build: 11,
      newFeatures: false,
      changes: [
        'Fixed Dark Theme bugs',
      ],
    ),
    Changelog(
      version: '1.2.0',
      build: 10,
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
}