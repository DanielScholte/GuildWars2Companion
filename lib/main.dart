import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/blocs/dungeons/bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/blocs/trading_post/bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/blocs/world_bosses/bloc.dart';
import 'package:guildwars2_companion/pages/tab.dart';
import 'package:guildwars2_companion/pages/token.dart';
import 'package:guildwars2_companion/repositories/account.dart';
import 'package:guildwars2_companion/repositories/bank.dart';
import 'package:guildwars2_companion/repositories/character.dart';
import 'package:guildwars2_companion/repositories/dungeons.dart';
import 'package:guildwars2_companion/repositories/item.dart';
import 'package:guildwars2_companion/repositories/trading_post.dart';
import 'package:guildwars2_companion/repositories/wallet.dart';
import 'package:guildwars2_companion/repositories/world_bosses.dart';
import 'package:guildwars2_companion/utils/token.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ItemRepository itemRepository = ItemRepository();
  await itemRepository.loadCachedData();

  bool tokenPresent = await TokenUtil.tokenPresent();

  runApp(GuildWars2Companion(
    itemRepository: itemRepository,
    isAuthenticated: tokenPresent,
  ));
}

class GuildWars2Companion extends StatelessWidget {
  final ItemRepository itemRepository;
  final bool isAuthenticated;

  GuildWars2Companion({
    @required this.isAuthenticated,
    @required this.itemRepository
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
          create: (BuildContext context) => AccountRepository(),
        ),
        RepositoryProvider<BankRepository>(
          create: (BuildContext context) => BankRepository(),
        ),
        RepositoryProvider<CharacterRepository>(
          create: (BuildContext context) => CharacterRepository(),
        ),
        RepositoryProvider<DungeonsRepository>(
          create: (BuildContext context) => DungeonsRepository(),
        ),
        RepositoryProvider<ItemRepository>(
          create: (BuildContext context) => itemRepository,
        ),
        RepositoryProvider<TradingPostRepository>(
          create: (BuildContext context) => TradingPostRepository(),
        ),
        RepositoryProvider<WalletRepository>(
          create: (BuildContext context) => WalletRepository(),
        ),
        RepositoryProvider<WorldBossesRepository>(
          create: (BuildContext context) => WorldBossesRepository(),
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
        BlocProvider<BankBloc>(
          create: (BuildContext context) => BankBloc(
            bankRepository: RepositoryProvider.of<BankRepository>(context),
            itemRepository: RepositoryProvider.of<ItemRepository>(context),
          ),
        ),
        BlocProvider<CharacterBloc>(
          create: (BuildContext context) => CharacterBloc(
            characterRepository: RepositoryProvider.of<CharacterRepository>(context),
            itemRepository: RepositoryProvider.of<ItemRepository>(context),
          ),
        ),
        BlocProvider<DungeonBloc>(
          create: (BuildContext context) => DungeonBloc(
            dungeonsRepository: RepositoryProvider.of<DungeonsRepository>(context),
          ),
        ),
        BlocProvider<TradingPostBloc>(
          create: (BuildContext context) => TradingPostBloc(
            itemRepository: RepositoryProvider.of<ItemRepository>(context),
            tradingPostRepository: RepositoryProvider.of<TradingPostRepository>(context)
          ),
        ),
        BlocProvider<WalletBloc>(
          create: (BuildContext context) => WalletBloc(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          ),
        ),
        BlocProvider<WorldBossesBloc>(
          create: (BuildContext context) => WorldBossesBloc(
            worldBossesRepository: RepositoryProvider.of<WorldBossesRepository>(context),
          ),
        ),
      ],
    );
  }

  // All: B2537E72-F213-E34F-8499-20FE02DA411216C368B9-75F1-41A5-B616-B447A1228A0B
  // None: E335E350-DEF3-8F4E-873F-F776BF00CC2F19D7D5FA-8129-4FF5-8C47-D9B3060957FF
}