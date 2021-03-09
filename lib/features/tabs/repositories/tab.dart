import 'package:guildwars2_companion/features/tabs/enums/tab_type.dart';
import 'package:guildwars2_companion/features/tabs/models/tab.dart';
import 'package:guildwars2_companion/features/tabs/services/tab.dart';
import 'package:meta/meta.dart';

class TabRepository {
  final TabService tabService;

  TabRepository({
    @required this.tabService
  });

  List<TabEntry> getTabs(List<TabType> types) => tabService.getTabs(types);
}