import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/tabs/models/tab.dart';
import 'package:guildwars2_companion/features/tabs/services/tab.dart';
import 'package:meta/meta.dart';

class TabRepository {
  final TabService tabService;

  TabRepository({
    @required this.tabService
  });

  List<TabEntry> getTabs(List<String> permissions) => tabService.getTabs(permissions);
}