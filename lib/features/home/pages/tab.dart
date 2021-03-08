import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/core/widgets/error.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';
import 'package:guildwars2_companion/features/account/pages/token.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/achievement/pages/progression.dart';
import 'package:guildwars2_companion/features/bank/bloc/bank_bloc.dart';
import 'package:guildwars2_companion/features/bank/pages/bank.dart';
import 'package:guildwars2_companion/features/changelog/widgets/changelog.dart';
import 'package:guildwars2_companion/features/character/bloc/character_bloc.dart';
import 'package:guildwars2_companion/features/character/pages/characters.dart';
import 'package:guildwars2_companion/features/home/pages/home.dart';
import 'package:guildwars2_companion/features/trading_post/bloc/bloc.dart';
import 'package:guildwars2_companion/features/trading_post/pages/trading_post.dart';
import 'package:guildwars2_companion/features/wallet/bloc/bloc.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    if (BlocProvider.of<AccountBloc>(context).state is AuthenticatedState) {
      _handleAuth(context, BlocProvider.of<AccountBloc>(context).state);
    }
  }

  List<TabEntry> _tabs = [
    TabEntry(HomePage(), "Home", FontAwesomeIcons.home, 20.0, Colors.red),
    TabEntry(ProgressionPage(), "Progression", GuildWarsIcons.achievement, 24.0, Colors.orange),
  ];
 
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark
      ),
      child: WillPopScope(
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
            return false;
          }
          return true;
        },
        child: BlocConsumer<AccountBloc, AccountState>(
          listenWhen: (previous, current) => current is UnauthenticatedState || current is AuthenticatedState,
          listener: (BuildContext context, state) async {
            if (state is AuthenticatedState) {
              await _handleAuth(context, state);
              return;
            }
            
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => TokenPage()));
          },
          buildWhen: (previous, current) => current is LoadingAccountState || current is AuthenticatedState,
          builder: (BuildContext context, state) {
            if (state is UnauthenticatedState) {
              return Scaffold(
                body: Center(
                  child: CompanionError(
                    title: 'the account',
                    onTryAgain: () async =>
                      BlocProvider.of<AccountBloc>(context).add(SetupAccountEvent()),
                  ),
                ),
              );
            }

            if (state is LoadingAccountState) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Loading account information',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return Stack(
              children: <Widget>[
                _buildTabPage(context, state),
                ChangelogPopup(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabPage(BuildContext context, AuthenticatedState authenticatedState) {
    return Scaffold(
      body: IndexedStack(
        children: _tabs.map((t) => t.widget).toList(),
        index: _currentIndex,
      ),
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        currentIndex: _currentIndex,
        opacity: 1,
        hasInk: true,
        inkColor: Color.fromRGBO(0, 0, 0, .15),
        onTap: (index) => setState(() => _currentIndex = index),
        items: _tabs.map((t) =>
          BubbleBottomBarItem(
            icon: Icon(
              t.icon,
              key: Key('Icon_${t.title}'),
              color: Theme.of(context).brightness == Brightness.light ? t.color : Colors.white70,
              size: t.iconSize,
            ),
            activeIcon: Icon(
              t.icon,
              key: Key('Icon_${t.title}_Active'),
              color: Colors.white,
              size: t.iconSize
            ),
            title: Text(
              t.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0
              ),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.light ? t.color : Theme.of(context).cardColor
          )
        ).toList(),
      ),
    );
  }

  Future<void> _handleAuth(BuildContext context, AuthenticatedState state) async {
    List<TabEntry> tabs = [
      TabEntry(HomePage(), "Home", FontAwesomeIcons.home, 20.0, Colors.red),
    ];

    if (state.tokenInfo.permissions.contains('characters')) {
      BlocProvider.of<CharacterBloc>(context).add(LoadCharactersEvent());
      tabs.add(TabEntry(CharactersPage(), "Characters", GuildWarsIcons.hero, 24.0, Colors.blue));
    }

    if (state.tokenInfo.permissions.contains('inventories')
      || state.tokenInfo.permissions.contains('builds')) {
      BlocProvider.of<BankBloc>(context).add(LoadBankEvent(
        loadBank: state.tokenInfo.permissions.contains('inventories'),
        loadBuilds: state.tokenInfo.permissions.contains('builds')
      ));
      tabs.add(TabEntry(BankPage(), "Bank", GuildWarsIcons.inventory, 24.0, Colors.indigo));
    }

    if (state.tokenInfo.permissions.contains('tradingpost')) {
      BlocProvider.of<TradingPostBloc>(context).add(LoadTradingPostEvent());
      tabs.add(TabEntry(TradingPostPage(), "Trading", FontAwesomeIcons.balanceScaleLeft, 20.0, Colors.green));
    }

    BlocProvider.of<AchievementBloc>(context).add(LoadAchievementsEvent(
      includeProgress: state.tokenInfo.permissions.contains('progression')
    ));
    tabs.add(TabEntry(ProgressionPage(), "Progression", GuildWarsIcons.achievement, 24.0, Colors.orange));

    if (state.tokenInfo.permissions.contains('wallet')) {
      BlocProvider.of<WalletBloc>(context).add(LoadWalletEvent());
    }
    
    _tabs = tabs;

    setState(() {});
    return;
  }
}

class TabEntry {
  Widget widget;
  String title;
  IconData icon;
  double iconSize;
  Color color;

  TabEntry(Widget widget, String title, IconData icon, double iconSize, Color color) {
    this.widget = widget;
    this.title = title;
    this.icon = icon;
    this.iconSize = iconSize;
    this.color = color;
  }
}
