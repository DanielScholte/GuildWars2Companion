import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/blocs/event/event_bloc.dart';
import 'package:guildwars2_companion/blocs/pvp/pvp_bloc.dart';
import 'package:guildwars2_companion/blocs/raid/raid_bloc.dart';
import 'package:guildwars2_companion/blocs/trading_post/bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/blocs/world_boss/bloc.dart';
import 'package:guildwars2_companion/pages/tab.dart';
import 'package:guildwars2_companion/pages/token/token.dart';
import 'package:guildwars2_companion/providers/configuration.dart';
import 'package:guildwars2_companion/repositories/account.dart';
import 'package:guildwars2_companion/repositories/achievement.dart';
import 'package:guildwars2_companion/repositories/bank.dart';
import 'package:guildwars2_companion/repositories/character.dart';
import 'package:guildwars2_companion/repositories/dungeon.dart';
import 'package:guildwars2_companion/repositories/event.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import 'package:guildwars2_companion/repositories/pvp.dart';
import 'package:guildwars2_companion/repositories/raid.dart';
import 'package:guildwars2_companion/repositories/trading_post.dart';
import 'package:guildwars2_companion/repositories/wallet.dart';
import 'package:guildwars2_companion/repositories/world_boss.dart';
import 'package:guildwars2_companion/services/account.dart';
import 'package:guildwars2_companion/services/achievement.dart';
import 'package:guildwars2_companion/services/bank.dart';
import 'package:guildwars2_companion/services/character.dart';
import 'package:guildwars2_companion/services/dungeon.dart';
import 'package:guildwars2_companion/services/event.dart';
import 'package:guildwars2_companion/services/item.dart';
import 'package:guildwars2_companion/services/map.dart';
import 'package:guildwars2_companion/services/pvp.dart';
import 'package:guildwars2_companion/services/raid.dart';
import 'package:guildwars2_companion/services/token.dart';
import 'package:guildwars2_companion/services/trading_post.dart';
import 'package:guildwars2_companion/services/wallet.dart';
import 'package:guildwars2_companion/services/world_boss.dart';
import 'package:guildwars2_companion/utils/dio.dart';
import 'package:guildwars2_companion/utils/theme.dart';
import 'package:provider/provider.dart';

import 'blocs/dungeon/bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final TokenService tokenService = TokenService();

  final ConfigurationProvider configurationProvider = ConfigurationProvider();
  await configurationProvider.loadConfiguration();

  final DioUtil dioUtil = DioUtil(
    tokenService: tokenService,
    configurationProvider: configurationProvider
  );

  final AccountService accountService = AccountService(
    dio: dioUtil.getDioInstance(
      includeTokenInterceptor: false
    )
  );

  final ItemService itemService = ItemService(
    dio: dioUtil.getDioInstance()
  );
  await itemService.loadCachedData();

  runApp(GuildWars2Companion(
    accountService: accountService,
    achievementService: AchievementService(dio: dioUtil.getDioInstance()),
    bankService: BankService(dio: dioUtil.getDioInstance()),
    characterService: CharacterService(dio: dioUtil.getDioInstance()),
    dungeonService: DungeonService(dio: dioUtil.getDioInstance()),
    eventService: EventService(),
    itemService: itemService,
    raidService: RaidService(dio: dioUtil.getDioInstance()),
    mapService: MapService(dio: dioUtil.getDioInstance()),
    pvpService: PvpService(dio: dioUtil.getDioInstance()),
    tokenService: tokenService,
    tradingPostService: TradingPostService(dio: dioUtil.getDioInstance()),
    walletService: WalletService(dio: dioUtil.getDioInstance()),
    worldBossService: WorldBossService(dio: dioUtil.getDioInstance()),
    configurationProvider: configurationProvider,
    isAuthenticated: await tokenService.tokenPresent(),
  ));
}

class GuildWars2Companion extends StatelessWidget {
  final AccountService accountService;
  final AchievementService achievementService;
  final BankService bankService;
  final CharacterService characterService;
  final DungeonService dungeonService;
  final EventService eventService;
  final ItemService itemService;
  final MapService mapService;
  final PvpService pvpService;
  final RaidService raidService;
  final TokenService tokenService;
  final TradingPostService tradingPostService;
  final WalletService walletService;
  final WorldBossService worldBossService;

  final ConfigurationProvider configurationProvider;

  final bool isAuthenticated;

  const GuildWars2Companion({
    @required this.accountService,
    @required this.achievementService,
    @required this.bankService,
    @required this.characterService,
    @required this.dungeonService,
    @required this.eventService,
    @required this.itemService,
    @required this.mapService,
    @required this.pvpService,
    @required this.raidService,
    @required this.tokenService,
    @required this.tradingPostService,
    @required this.walletService,
    @required this.worldBossService,
    @required this.configurationProvider,
    @required this.isAuthenticated
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return _initializeRepositories(
      child: _initializeBlocs(
        child: _initializeConfiguration(
          builder: (context, state, child) {
            return MaterialApp(
              title: 'Guild Wars 2 Companion',
              theme: ThemeUtil.getLightTheme(),
              darkTheme: ThemeUtil.getDarkTheme(),
              themeMode: state.themeMode,
              home: isAuthenticated ? TabPage() : TokenPage(),
            );
          }
        ) ,
      ),
    );
  }

  Widget _initializeRepositories({Widget child}) {
    return MultiRepositoryProvider(
      child: child,
      providers: [
        RepositoryProvider<AccountRepository>(
          create: (BuildContext context) => AccountRepository(
            accountService: accountService,
            tokenService: tokenService,
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
        RepositoryProvider<EventRepository>(
          create: (BuildContext context) => EventRepository(
            eventService: eventService,
          ),
        ),
        RepositoryProvider<ItemRepository>(
          create: (BuildContext context) => ItemRepository(
            itemService: itemService,
          ),
        ),
        RepositoryProvider<PvpRepository>(
          create: (BuildContext context) => PvpRepository(
            mapService: mapService,
            pvpService: pvpService,
          ),
        ),
        RepositoryProvider<RaidRepository>(
          create: (BuildContext context) => RaidRepository(
            raidService: raidService,
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
        BlocProvider<EventBloc>(
          create: (BuildContext context) => EventBloc(
            eventRepository: RepositoryProvider.of<EventRepository>(context),
          ),
        ),
        BlocProvider<PvpBloc>(
          create: (BuildContext context) => PvpBloc(
            pvpRepository: RepositoryProvider.of<PvpRepository>(context),
          ),
        ),
        BlocProvider<RaidBloc>(
          create: (BuildContext context) => RaidBloc(
            raidRepository: RepositoryProvider.of<RaidRepository>(context),
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

  Widget _initializeConfiguration({
    Widget Function(BuildContext, ConfigurationProvider, Widget) builder
  }) {
    return ChangeNotifierProvider<ConfigurationProvider>(
      create: (context) => configurationProvider,
      child: Consumer<ConfigurationProvider>(
        builder: builder,
      ),
    );
  }
}
