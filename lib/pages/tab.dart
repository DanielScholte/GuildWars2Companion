import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/pages/tabs/bank.dart';
import 'package:guildwars2_companion/pages/tabs/characters.dart';
import 'package:guildwars2_companion/pages/tabs/home.dart';
import 'package:guildwars2_companion/pages/token.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';

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
    TabEntry(Scaffold(), "Progression", Icons.crop_square, 24.0, Colors.orange),
  ];
 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark
    ));

    return BlocListener<AccountBloc, AccountState>(
      condition: (previous, current) => current is UnauthenticatedState || current is AuthenticatedState,
      listener: (BuildContext context, state) async {
        if (state is AuthenticatedState) {
          await _handleAuth(context, state);
          return;
        }

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => TokenPage()));
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        condition: (previous, current) => current is LoadingAccountState || current is AuthenticatedState,
        builder: (BuildContext context, state) {
          if (state is LoadingAccountState) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return _buildTabPage(context, state);
        },
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
              color: t.color,
              size: t.iconSize,
            ),
            activeIcon: Icon(
              t.icon,
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
            backgroundColor: t.color
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

    if (state.tokenInfo.permissions.contains('inventories')) {
      BlocProvider.of<BankBloc>(context).add(LoadBankEvent());
      tabs.add(TabEntry(BankPage(), "Bank", GuildWarsIcons.inventory, 24.0, Colors.indigo));
    }

    if (state.tokenInfo.permissions.contains('tradingpost')) {
      tabs.add(TabEntry(Scaffold(), "Trading Post", FontAwesomeIcons.balanceScaleLeft, 20.0, Colors.green));
    }

    if (state.tokenInfo.permissions.contains('wallet')) {
      BlocProvider.of<WalletBloc>(context).add(LoadWalletEvent());
    }

    tabs.add(TabEntry(Scaffold(), "Progression", GuildWarsIcons.achievement, 24.0, Colors.orange));
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