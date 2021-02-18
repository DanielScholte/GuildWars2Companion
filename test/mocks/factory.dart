import 'package:guildwars2_companion/factory.dart';
import 'package:guildwars2_companion/features/changelog/services/changelog.dart';
import 'package:guildwars2_companion/features/configuration/services/configuration.dart';
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
    raidService = MockRaidService();
    mapService = MockMapService();
    pvpService = MockPvpService();
    tokenService = MockTokenService();
    tradingPostService = MockTradingPostService();
    walletService = MockWalletService();
    worldBossService = MockWorldBossService();

    changelogService = ChangelogService();
    configurationService = ConfigurationService();
  }
}