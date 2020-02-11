
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guildwars2_companion/main.dart';
import 'package:guildwars2_companion/models/account/account.dart';
import 'package:guildwars2_companion/models/account/token_info.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/profession.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/info_box.dart';
import 'package:mockito/mockito.dart';

import 'mocks/services.dart';

main() {
  group('Token Permissions tests', () {
    MockAccountService accountService;
    MockAchievementService achievementService;
    MockBankService bankService;
    MockCharacterService characterService;
    MockDungeonService dungeonService;
    MockEventService eventService;
    MockItemService itemService;
    MockRaidService raidService;
    MockTokenService tokenService;
    MockTradingPostService tradingPostService;
    MockWalletService walletService;
    MockWorldBossService worldBossService;

    setUp(() {
      accountService = MockAccountService();
      achievementService = MockAchievementService();
      bankService = MockBankService();
      characterService = MockCharacterService();
      dungeonService = MockDungeonService();
      eventService = MockEventService();
      itemService = MockItemService();
      raidService = MockRaidService();
      tokenService = MockTokenService();
      tradingPostService = MockTradingPostService();
      walletService = MockWalletService();
      worldBossService = MockWorldBossService();

      when(tokenService.tokenPresent())
        .thenAnswer((_) async => true);

      when(accountService.getAccount(any))
        .thenAnswer((_) async => Account(
          name: 'Unit Test Account',
          age: 10000,
          dailyAp: 0,
          monthlyAp: 0,
        ));
      
      when(characterService.getCharacters())
        .thenAnswer((_) async => [
          Character(
            name: 'Unit Test Character',
            level: 80,
            race: 'Asura',
            profession: 'Guardian',
            age: 10000,
            title: 0,
          ),
        ]);
      when(characterService.getProfessions())
        .thenAnswer((_) async => [
          Profession(
            id: 'Guardian',
            name: 'Guardian',
          ),
        ]);
      when(characterService.getTitles())
        .thenAnswer((_) async => []);
    });

    testWidgets('Full permissions test', (WidgetTester tester) async {

      when(accountService.getTokenInfo(any))
        .thenAnswer((_) async => TokenInfo(
          permissions: [
            'account',
            'builds',
            'characters',
            'guilds',
            'inventories',
            'progression',
            'pvp',
            'tradingpost',
            'unlocks',
            'wallet',
          ],
        ));

      await tester.pumpWidget(GuildWars2Companion(
        accountService: accountService,
        achievementService: achievementService,
        bankService: bankService,
        characterService: characterService,
        dungeonService: dungeonService,
        eventService: eventService,
        itemService: itemService,
        raidService: raidService,
        tokenService: tokenService,
        tradingPostService: tradingPostService,
        walletService: walletService,
        worldBossService: worldBossService,
        isAuthenticated: true,
      ));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(CompanionInfoBox, 'Playtime'), findsOneWidget);
      expect(find.widgetWithText(CompanionInfoBox, 'Mastery level'), findsOneWidget);
      expect(find.widgetWithText(CompanionInfoBox, 'Achievements'), findsOneWidget);

      expect(find.widgetWithText(CompanionButton, 'Wallet'), findsOneWidget);
      expect(find.widgetWithText(CompanionButton, 'World bosses'), findsOneWidget);
      expect(find.widgetWithText(CompanionButton, 'Meta Events'), findsOneWidget);
      
      await tester.drag(find.widgetWithText(ListView, 'Meta Events'), Offset(0.0, -500));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(CompanionButton, 'Raids'), findsOneWidget);
      expect(find.widgetWithText(CompanionButton, 'Dungeons'), findsOneWidget);

      expect(find.byKey(Key('Icon_Home_Active')), findsOneWidget);
      expect(find.byKey(Key('Icon_Characters')), findsOneWidget);
      expect(find.byKey(Key('Icon_Bank')), findsOneWidget);
      expect(find.byKey(Key('Icon_Trading')), findsOneWidget);
      expect(find.byKey(Key('Icon_Progression')), findsOneWidget);

      // T O D O: Check character screen
    });
  });
}