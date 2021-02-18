import 'package:guildwars2_companion/features/account/services/account.dart';
import 'package:guildwars2_companion/features/achievement/services/achievement.dart';
import 'package:guildwars2_companion/features/bank/services/bank.dart';
import 'package:guildwars2_companion/features/build/services/build.dart';
import 'package:guildwars2_companion/features/character/services/character.dart';
import 'package:guildwars2_companion/features/dungeon/services/dungeon.dart';
import 'package:guildwars2_companion/features/meta_event/services/event.dart';
import 'package:guildwars2_companion/features/item/services/item.dart';
import 'package:guildwars2_companion/features/pvp/services/map.dart';
import 'package:guildwars2_companion/features/pvp/services/pvp.dart';
import 'package:guildwars2_companion/features/raid/services/raid.dart';
import 'package:guildwars2_companion/features/account/services/token.dart';
import 'package:guildwars2_companion/features/trading_post/services/trading_post.dart';
import 'package:guildwars2_companion/features/wallet/services/wallet.dart';
import 'package:guildwars2_companion/features/world_boss/services/world_boss.dart';
import 'package:mockito/mockito.dart';

class MockAccountService extends Mock implements AccountService {}
class MockAchievementService extends Mock implements AchievementService {}
class MockBankService extends Mock implements BankService {}
class MockBuildService extends Mock implements BuildService {}
class MockCharacterService extends Mock implements CharacterService {}
class MockDungeonService extends Mock implements DungeonService {}
class MockEventService extends Mock implements EventService {}
class MockItemService extends Mock implements ItemService {}
class MockRaidService extends Mock implements RaidService {}
class MockMapService extends Mock implements MapService {}
class MockPvpService extends Mock implements PvpService {}
class MockTokenService extends Mock implements TokenService {}
class MockTradingPostService extends Mock implements TradingPostService {}
class MockWalletService extends Mock implements WalletService {}
class MockWorldBossService extends Mock implements WorldBossService {}