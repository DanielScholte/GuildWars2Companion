import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/changelog.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangelogProvider extends ChangeNotifier {
  int lastLaunchBuildNumber = 0;
  int currentBuildNumber = 0;
  List<Changelog> _changelog = [
    Changelog(
      version: 7,
      changes: [
        "Dark theme",
        "Language configuration",
      ],
    ),
    Changelog(
      version: 5,
      changes: [
        "The new PvP section",
      ],
    ),
  ];

  Future<void> loadChangelogData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastLaunchBuildNumber = prefs.getInt("lastlaunch_buildnumber") ?? 0;

    PackageInfo platformInfo = await PackageInfo.fromPlatform();
    currentBuildNumber = int.tryParse(platformInfo.buildNumber) ?? 0;
  }

  bool anyNewChangelog() {
    return 
      currentBuildNumber > lastLaunchBuildNumber &&
      _changelog.any((c) => c.version > lastLaunchBuildNumber) &&
      (lastLaunchBuildNumber != 0 || DateTime.now().isBefore(DateTime.utc(2020, 3, 6)));
  }

  List<String> getChanges() {
    return _changelog.map((c) => c.changes).expand((i) => i).take(10).toList();
  }
}