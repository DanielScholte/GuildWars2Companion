import 'package:guildwars2_companion/services/account.dart';
import 'package:guildwars2_companion/services/achievement.dart';
import 'package:guildwars2_companion/services/bank.dart';
import 'package:guildwars2_companion/services/character.dart';
import 'package:guildwars2_companion/services/dungeon.dart';
import 'package:guildwars2_companion/services/event.dart';
import 'package:guildwars2_companion/services/item.dart';
import 'package:guildwars2_companion/services/raid.dart';
import 'package:guildwars2_companion/services/token.dart';
import 'package:guildwars2_companion/services/trading_post.dart';
import 'package:guildwars2_companion/services/wallet.dart';
import 'package:guildwars2_companion/services/world_boss.dart';
import 'package:mockito/mockito.dart';

class MockAccountService extends Mock implements AccountService {}
class MockAchievementService extends Mock implements AchievementService {}
class MockBankService extends Mock implements BankService {}
class MockCharacterService extends Mock implements CharacterService {}
class MockDungeonService extends Mock implements DungeonService {}
class MockEventService extends Mock implements EventService {}
class MockItemService extends Mock implements ItemService {}
class MockRaidService extends Mock implements RaidService {}
class MockTokenService extends Mock implements TokenService {}
class MockTradingPostService extends Mock implements TradingPostService {}
class MockWalletService extends Mock implements WalletService {}
class MockWorldBossService extends Mock implements WorldBossService {}