import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/bloc.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/blocs/trading_post/bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/blocs/world_bosses/bloc.dart';
import 'package:guildwars2_companion/pages/tab.dart';
import 'package:guildwars2_companion/pages/token/token.dart';
import 'package:guildwars2_companion/services/account.dart';
import 'package:guildwars2_companion/services/achievement.dart';
import 'package:guildwars2_companion/services/bank.dart';
import 'package:guildwars2_companion/services/character.dart';
import 'package:guildwars2_companion/services/dungeon.dart';
import 'package:guildwars2_companion/services/item.dart';
import 'package:guildwars2_companion/services/trading_post.dart';
import 'package:guildwars2_companion/services/wallet.dart';
import 'package:guildwars2_companion/services/world_bosses.dart';
import 'package:guildwars2_companion/utils/token.dart';

import 'blocs/dungeon/bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ItemService itemRepository = ItemService();
  await itemRepository.loadCachedData();

  runApp(GuildWars2Companion(
    itemRepository: itemRepository,
    isAuthenticated: await TokenUtil.tokenPresent(),
  ));
}

class GuildWars2Companion extends StatelessWidget {
  final ItemService itemRepository;

  final bool isAuthenticated;

  GuildWars2Companion({
    @required this.isAuthenticated,
    @required this.itemRepository,
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
        RepositoryProvider<AccountService>(
          create: (BuildContext context) => AccountService(),
        ),
        RepositoryProvider<AchievementService>(
          create: (BuildContext context) => AchievementService(),
        ),
        RepositoryProvider<BankService>(
          create: (BuildContext context) => BankService(),
        ),
        RepositoryProvider<CharacterService>(
          create: (BuildContext context) => CharacterService(),
        ),
        RepositoryProvider<DungeonService>(
          create: (BuildContext context) => DungeonService(),
        ),
        RepositoryProvider<ItemService>(
          create: (BuildContext context) => itemRepository,
        ),
        RepositoryProvider<TradingPostService>(
          create: (BuildContext context) => TradingPostService(),
        ),
        RepositoryProvider<WalletService>(
          create: (BuildContext context) => WalletService(),
        ),
        RepositoryProvider<WorldBossesService>(
          create: (BuildContext context) => WorldBossesService(),
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
            accountRepository: RepositoryProvider.of<AccountService>(context),
          ),
        ),
        BlocProvider<AchievementBloc>(
          create: (BuildContext context) => AchievementBloc(
            achievementRepository: RepositoryProvider.of<AchievementService>(context),
            characterRepository: RepositoryProvider.of<CharacterService>(context),
            itemRepository: RepositoryProvider.of<ItemService>(context),
          ),
        ),
        BlocProvider<BankBloc>(
          create: (BuildContext context) => BankBloc(
            bankRepository: RepositoryProvider.of<BankService>(context),
            itemRepository: RepositoryProvider.of<ItemService>(context),
          ),
        ),
        BlocProvider<CharacterBloc>(
          create: (BuildContext context) => CharacterBloc(
            characterRepository: RepositoryProvider.of<CharacterService>(context),
            itemRepository: RepositoryProvider.of<ItemService>(context),
          ),
        ),
        BlocProvider<DungeonBloc>(
          create: (BuildContext context) => DungeonBloc(
            dungeonsRepository: RepositoryProvider.of<DungeonService>(context),
          ),
        ),
        BlocProvider<TradingPostBloc>(
          create: (BuildContext context) => TradingPostBloc(
            itemRepository: RepositoryProvider.of<ItemService>(context),
            tradingPostRepository: RepositoryProvider.of<TradingPostService>(context)
          ),
        ),
        BlocProvider<WalletBloc>(
          create: (BuildContext context) => WalletBloc(
            walletRepository: RepositoryProvider.of<WalletService>(context),
          ),
        ),
        BlocProvider<WorldBossesBloc>(
          create: (BuildContext context) => WorldBossesBloc(
            worldBossesRepository: RepositoryProvider.of<WorldBossesService>(context),
          ),
        ),
      ],
    );
  }

  // All: B2537E72-F213-E34F-8499-20FE02DA411216C368B9-75F1-41A5-B616-B447A1228A0B
  // None: E335E350-DEF3-8F4E-873F-F776BF00CC2F19D7D5FA-8129-4FF5-8C47-D9B3060957FF
}
