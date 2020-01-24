import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/blocs/trading_post/bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/blocs/world_boss/bloc.dart';
import 'package:guildwars2_companion/pages/tab.dart';
import 'package:guildwars2_companion/pages/token/token.dart';
import 'package:guildwars2_companion/repositories/account.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import 'package:guildwars2_companion/repositories/bank.dart';
import 'package:guildwars2_companion/repositories/character.dart';
import 'package:guildwars2_companion/repositories/dungeon.dart';
import 'package:guildwars2_companion/repositories/trading_post.dart';
import 'package:guildwars2_companion/repositories/wallet.dart';
import 'package:guildwars2_companion/repositories/world_boss.dart';
import 'package:guildwars2_companion/services/account.dart';
import 'package:guildwars2_companion/services/achievement.dart';
import 'package:guildwars2_companion/services/bank.dart';
import 'package:guildwars2_companion/services/character.dart';
import 'package:guildwars2_companion/services/dungeon.dart';
import 'package:guildwars2_companion/services/item.dart';
import 'package:guildwars2_companion/services/trading_post.dart';
import 'package:guildwars2_companion/services/wallet.dart';
import 'package:guildwars2_companion/services/world_boss.dart';
import 'package:guildwars2_companion/utils/token.dart';

import 'blocs/dungeon/bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ItemService itemService = ItemService();
  await itemService.loadCachedData();

  runApp(GuildWars2Companion(
    accountService: AccountService(),
    achievementService: AchievementService(),
    bankService: BankService(),
    characterService: CharacterService(),
    dungeonService: DungeonService(),
    itemService: itemService,
    tradingPostService: TradingPostService(),
    walletService: WalletService(),
    worldBossService: WorldBossService(),
    isAuthenticated: await TokenUtil.tokenPresent(),
  ));
}

class GuildWars2Companion extends StatelessWidget {
  final AccountService accountService;
  final AchievementService achievementService;
  final BankService bankService;
  final CharacterService characterService;
  final DungeonService dungeonService;
  final ItemService itemService;
  final TradingPostService tradingPostService;
  final WalletService walletService;
  final WorldBossService worldBossService;

  final bool isAuthenticated;

  const GuildWars2Companion({
    @required this.accountService,
    @required this.achievementService,
    @required this.bankService,
    @required this.characterService,
    @required this.dungeonService,
    @required this.itemService,
    @required this.tradingPostService,
    @required this.walletService,
    @required this.worldBossService,
    @required this.isAuthenticated
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return _initializeRepositories(
      child: _initializeBlocs(
        child: MaterialApp(
          title: 'Guild Wars 2 Companion',
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Color(0xFFAA0404),
            accentColor: Colors.red,
            scaffoldBackgroundColor: Color(0xFFEEEEEE),
            cursorColor: Color(0xFFAA0404),
          ),
          home: isAuthenticated ? TabPage() : TokenPage(),
        ),
      ),
    );
  }

  Widget _initializeRepositories({Widget child}) {
    return MultiRepositoryProvider(
      child: child,
      providers: [
        RepositoryProvider<AccountRepository>(
          create: (BuildContext context) => AccountRepository(
            accountService: accountService
          ),
        ),
        RepositoryProvider<AchievementRepository>(
          create: (BuildContext context) => AchievementRepository(
            achievementService: achievementService,
            characterService: characterService,
            itemService: itemService,
          ),
        ),
        RepositoryProvider<BankRepository>(
          create: (BuildContext context) => BankRepository(
            bankService: bankService,
            itemService: itemService,
          ),
        ),
        RepositoryProvider<CharacterRepository>(
          create: (BuildContext context) => CharacterRepository(
            characterService: characterService,
            itemService: itemService,
          ),
        ),
        RepositoryProvider<DungeonRepository>(
          create: (BuildContext context) => DungeonRepository(
            dungeonService: dungeonService,
          ),
        ),
        RepositoryProvider<TradingPostRepository>(
          create: (BuildContext context) => TradingPostRepository(
            itemService: itemService,
            tradingPostService: tradingPostService,
          ),
        ),
        RepositoryProvider<WalletRepository>(
          create: (BuildContext context) => WalletRepository(
            walletService: walletService,
          ),
        ),
        RepositoryProvider<WorldBossRepository>(
          create: (BuildContext context) => WorldBossRepository(
            worldBossService: worldBossService
          ),
        ),
      ],
    );
  }

  Widget _initializeBlocs({Widget child}) {
    return MultiBlocProvider(
      child: child,
      providers: [
        BlocProvider<AccountBloc>(
          create: (BuildContext context) => AccountBloc(
            accountRepository: RepositoryProvider.of<AccountRepository>(context),
          ),
        ),
        BlocProvider<AchievementBloc>(
          create: (BuildContext context) => AchievementBloc(
            achievementRepository: RepositoryProvider.of<AchievementRepository>(context),
          ),
        ),
        BlocProvider<BankBloc>(
          create: (BuildContext context) => BankBloc(
            bankRepository: RepositoryProvider.of<BankRepository>(context),
          ),
        ),
        BlocProvider<CharacterBloc>(
          create: (BuildContext context) => CharacterBloc(
            characterRepository: RepositoryProvider.of<CharacterRepository>(context),
          ),
        ),
        BlocProvider<DungeonBloc>(
          create: (BuildContext context) => DungeonBloc(
            dungeonRepository: RepositoryProvider.of<DungeonRepository>(context),
          ),
        ),
        BlocProvider<TradingPostBloc>(
          create: (BuildContext context) => TradingPostBloc(
            tradingPostRepository: RepositoryProvider.of<TradingPostRepository>(context)
          ),
        ),
        BlocProvider<WalletBloc>(
          create: (BuildContext context) => WalletBloc(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          ),
        ),
        BlocProvider<WorldBossBloc>(
          create: (BuildContext context) => WorldBossBloc(
            worldBossRepository: RepositoryProvider.of<WorldBossRepository>(context),
          ),
        ),
      ],
    );
  }

  // All: B2537E72-F213-E34F-8499-20FE02DA411216C368B9-75F1-41A5-B616-B447A1228A0B
  // None: E335E350-DEF3-8F4E-873F-F776BF00CC2F19D7D5FA-8129-4FF5-8C47-D9B3060957FF
}
