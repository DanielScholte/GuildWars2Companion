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
      version: '1.5.1',
      build: 29,
      newFeatures: false,
      changes: [
        'Fixed typo on the schedule notification page',
        'Fixed notification text issue'
      ],
    ),
    Changelog(
      version: '1.5.0',
      build: 28,
      newFeatures: true,
      changes: [
        'Added notifications for World bosses and meta events',
        'Improved the bank page',
        'Improved the inventory page (Thanks to Apcro)',
        'Improved the wallet page (Thanks to Apcro)'
      ],
    ),
    Changelog(
      version: '1.4.3',
      build: 23,
      newFeatures: false,
      changes: [
        'Fixed an alignment bug on iOS',
        'Fixed an issue where the achievement points were calculated incorrectly',
        'Added a link to the github page'
      ],
    ),
    Changelog(
      version: '1.4.2',
      build: 22,
      newFeatures: false,
      changes: [
        'Fixed a bug with non-legendary gear and upgrades'
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