import 'package:guildwars2_companion/factory.dart';
import 'package:guildwars2_companion/features/changelog/services/changelog.dart';
import 'package:guildwars2_companion/features/configuration/services/configuration.dart';
import 'package:guildwars2_companion/features/permissions/services/permission.dart';
import 'package:guildwars2_companion/features/tabs/services/tab.dart';
import 'services.dart';

class MockCompanionFactory extends CompanionFactory {
  @override
  Future<void> initializeServices() async {
    accountService = MockAccountService();
    achievementService = MockAchievementService();
    bankService = MockBankService();
    buildService = MockBuildService();
    characterService = MockCharacterService();
    dungeonService = MockDungeonService();
    eventService = MockEventService();
    itemService = MockItemService();
    mapService = MockMapService();
    notificationService = MockNotificationService();
    permissionService = PermissionService();
    pvpService = MockPvpService();
    raidService = MockRaidService();
    tabService = TabService();
    tokenService = MockTokenService();
    tradingPostService = MockTradingPostService();
    walletService = MockWalletService();
    worldBossService = MockWorldBossService();

    changelogService = ChangelogService();
    configurationService = ConfigurationService();
  }
}