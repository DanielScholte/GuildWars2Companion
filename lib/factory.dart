import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/dio.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';
import 'package:guildwars2_companion/features/account/repositories/account.dart';
import 'package:guildwars2_companion/features/account/services/account.dart';
import 'package:guildwars2_companion/features/account/services/token.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/achievement/repositories/achievement.dart';
import 'package:guildwars2_companion/features/achievement/services/achievement.dart';
import 'package:guildwars2_companion/features/bank/bloc/bank_bloc.dart';
import 'package:guildwars2_companion/features/bank/repositories/bank.dart';
import 'package:guildwars2_companion/features/bank/services/bank.dart';
import 'package:guildwars2_companion/features/build/repositories/build.dart';
import 'package:guildwars2_companion/features/build/services/build.dart';
import 'package:guildwars2_companion/features/changelog/bloc/changelog_bloc.dart';
import 'package:guildwars2_companion/features/changelog/repositories/changelog.dart';
import 'package:guildwars2_companion/features/changelog/services/changelog.dart';
import 'package:guildwars2_companion/features/character/bloc/character_bloc.dart';
import 'package:guildwars2_companion/features/character/repositories/character.dart';
import 'package:guildwars2_companion/features/character/services/character.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/features/configuration/repositories/configuration.dart';
import 'package:guildwars2_companion/features/configuration/services/configuration.dart';
import 'package:guildwars2_companion/features/dungeon/bloc/dungeon_bloc.dart';
import 'package:guildwars2_companion/features/dungeon/repositories/dungeon.dart';
import 'package:guildwars2_companion/features/dungeon/services/dungeon.dart';
import 'package:guildwars2_companion/features/event/bloc/notification_bloc.dart';
import 'package:guildwars2_companion/features/event/repositories/notification.dart';
import 'package:guildwars2_companion/features/event/services/notification.dart';
import 'package:guildwars2_companion/features/item/repositories/item.dart';
import 'package:guildwars2_companion/features/item/services/item.dart';
import 'package:guildwars2_companion/features/meta_event/bloc/event_bloc.dart';
import 'package:guildwars2_companion/features/meta_event/repositories/event.dart';
import 'package:guildwars2_companion/features/meta_event/services/event.dart';
import 'package:guildwars2_companion/features/pvp/bloc/pvp_bloc.dart';
import 'package:guildwars2_companion/features/pvp/repositories/pvp.dart';
import 'package:guildwars2_companion/features/pvp/services/map.dart';
import 'package:guildwars2_companion/features/pvp/services/pvp.dart';
import 'package:guildwars2_companion/features/raid/bloc/raid_bloc.dart';
import 'package:guildwars2_companion/features/raid/repositories/raid.dart';
import 'package:guildwars2_companion/features/raid/services/raid.dart';
import 'package:guildwars2_companion/features/tabs/bloc/tab_bloc.dart';
import 'package:guildwars2_companion/features/tabs/repositories/tab.dart';
import 'package:guildwars2_companion/features/tabs/services/tab.dart';
import 'package:guildwars2_companion/features/trading_post/bloc/bloc.dart';
import 'package:guildwars2_companion/features/trading_post/repositories/trading_post.dart';
import 'package:guildwars2_companion/features/trading_post/services/trading_post.dart';
import 'package:guildwars2_companion/features/wallet/bloc/bloc.dart';
import 'package:guildwars2_companion/features/wallet/repositories/wallet.dart';
import 'package:guildwars2_companion/features/wallet/services/wallet.dart';
import 'package:guildwars2_companion/features/world_boss/bloc/bloc.dart';
import 'package:guildwars2_companion/features/world_boss/repositories/world_boss.dart';
import 'package:guildwars2_companion/features/world_boss/services/world_boss.dart';

class CompanionFactory {
  AccountService accountService;
  AchievementService achievementService;
  BankService bankService;
  BuildService buildService;
  ChangelogService changelogService;
  CharacterService characterService;
  ConfigurationService configurationService;
  DungeonService dungeonService;
  EventService eventService;
  ItemService itemService;
  MapService mapService;
  NotificationService notificationService;
  PvpService pvpService;
  RaidService raidService;
  TabService tabService;
  TokenService tokenService;
  TradingPostService tradingPostService;
  WalletService walletService;
  WorldBossService worldBossService;

  Future<void> initializeServices() async {
    tokenService = TokenService();

    configurationService = ConfigurationService();
    await configurationService.loadConfiguration();

    changelogService = ChangelogService();
    await changelogService.loadChangelogData();

    notificationService = NotificationService();
    await notificationService.initializeNotifications();

    final DioUtil dioUtil = DioUtil(
      tokenService: tokenService,
      configurationService: configurationService
    );

    buildService = BuildService(
      dio: dioUtil.getDioInstance()
    );
    await buildService.loadCachedData();

    itemService = ItemService(
      dio: dioUtil.getDioInstance()
    );
    await itemService.loadCachedData();

    accountService = AccountService(dio: dioUtil.getDioInstance(includeTokenInterceptor: false));
    achievementService = AchievementService(dio: dioUtil.getDioInstance());
    bankService = BankService(dio: dioUtil.getDioInstance());
    characterService = CharacterService(dio: dioUtil.getDioInstance());
    dungeonService = DungeonService(dio: dioUtil.getDioInstance());
    eventService = EventService();
    raidService = RaidService(dio: dioUtil.getDioInstance());
    mapService = MapService(dio: dioUtil.getDioInstance());
    pvpService = PvpService(dio: dioUtil.getDioInstance());
    tabService = TabService();
    tradingPostService = TradingPostService(dio: dioUtil.getDioInstance());
    walletService = WalletService(dio: dioUtil.getDioInstance());
    worldBossService = WorldBossService(dio: dioUtil.getDioInstance());
  }

  Widget initializeRepositories({ @required Widget child }) {
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
        RepositoryProvider<BuildRepository>(
          create: (BuildContext context) => BuildRepository(
            buildService: buildService,
          ),
        ),
        RepositoryProvider<ChangelogRepository>(
          create: (BuildContext context) => ChangelogRepository(
            changelogService: changelogService
          ),
        ),
        RepositoryProvider<CharacterRepository>(
          create: (BuildContext context) => CharacterRepository(
            characterService: characterService,
            itemService: itemService,
          ),
        ),
        RepositoryProvider<ConfigurationRepository>(
          create: (BuildContext context) => ConfigurationRepository(
            configurationService: configurationService
          ),
        ),
        RepositoryProvider<DungeonRepository>(
          create: (BuildContext context) => DungeonRepository(
            dungeonService: dungeonService,
          ),
        ),
        RepositoryProvider<MetaEventRepository>(
          create: (BuildContext context) => MetaEventRepository(
            eventService: eventService,
          ),
        ),
        RepositoryProvider<ItemRepository>(
          create: (BuildContext context) => ItemRepository(
            itemService: itemService,
          ),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (BuildContext context) => NotificationRepository(
            notificationService: notificationService,
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
        RepositoryProvider<TabRepository>(
          create: (BuildContext context) => TabRepository(
            tabService: tabService
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

  Widget initializeBlocs({ @required Widget child }) {
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
            buildRepository: RepositoryProvider.of<BuildRepository>(context),
          ),
        ),
        BlocProvider<ChangelogBloc>(
          create: (BuildContext context) => ChangelogBloc(
            changelogRepository: RepositoryProvider.of<ChangelogRepository>(context),
          ),
        ),
        BlocProvider<CharacterBloc>(
          create: (BuildContext context) => CharacterBloc(
            buildRepository: RepositoryProvider.of<BuildRepository>(context),
            characterRepository: RepositoryProvider.of<CharacterRepository>(context),
          ),
        ),
        BlocProvider<ConfigurationBloc>(
          create: (BuildContext context) => ConfigurationBloc(
            configurationRepository: RepositoryProvider.of<ConfigurationRepository>(context),
          ),
        ),
        BlocProvider<DungeonBloc>(
          create: (BuildContext context) => DungeonBloc(
            dungeonRepository: RepositoryProvider.of<DungeonRepository>(context),
          ),
        ),
        BlocProvider<MetaEventBloc>(
          create: (BuildContext context) => MetaEventBloc(
            eventRepository: RepositoryProvider.of<MetaEventRepository>(context),
          ),
        ),
        BlocProvider<NotificationBloc>(
          create: (BuildContext context) => NotificationBloc(
            notificationRepository: RepositoryProvider.of<NotificationRepository>(context),
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
        BlocProvider<TabBloc>(
          create: (BuildContext context) => TabBloc(
            tabRepository: RepositoryProvider.of<TabRepository>(context)
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
            eventRepository: RepositoryProvider.of<MetaEventRepository>(context),
            worldBossRepository: RepositoryProvider.of<WorldBossRepository>(context),
          ),
        ),
      ],
    );
  }
}