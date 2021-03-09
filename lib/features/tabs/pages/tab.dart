import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/features/account/repositories/permission.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';
import 'package:guildwars2_companion/features/account/pages/token.dart';
import 'package:guildwars2_companion/features/account/widgets/layout.dart';
import 'package:guildwars2_companion/features/changelog/widgets/changelog.dart';
import 'package:guildwars2_companion/features/tabs/bloc/tab_bloc.dart';
import 'package:guildwars2_companion/features/tabs/models/tab.dart';

class TabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        TabState tabState = BlocProvider.of<TabBloc>(context).state;

        if (tabState is TabInitializedState && tabState.index != 0) {
          BlocProvider.of<TabBloc>(context).add(SelectTabEvent(0));
          return false;
        }

        return true;
      },
      child: BlocConsumer<AccountBloc, AccountState>(
        listenWhen: (previous, current) => current is UnauthenticatedState || current is AuthenticatedState,
        listener: (BuildContext context, state) async {
          if (state is AuthenticatedState) {
            // Load Bloc data
            RepositoryProvider.of<PermissionRepository>(context).loadBlocsWithPermissions(
              context: context,
              permissions: state.tokenInfo.permissions
            );
            // Set tabs by permissions
            BlocProvider.of<TabBloc>(context).add(SetAvailableTabsEvent(
              permissions: state.tokenInfo.permissions
            ));
            return;
          }
          
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => TokenPage()));
        },
        buildWhen: (previous, current) => current is LoadingAccountState || current is AuthenticatedState,
        builder: (BuildContext context, state) {
          if (state is UnauthenticatedState) {
            return Scaffold(
              body: TokenLayout(
                child: Center(
                  child: CompanionError(
                    title: 'the account',
                    onTryAgain: () async =>
                      BlocProvider.of<AccountBloc>(context).add(SetupAccountEvent()),
                  ),
                ),
              ),
            );
          }

          return BlocBuilder<TabBloc, TabState>(
            buildWhen: (_, curr) => curr is TabInitializedState,
            builder: (context, tabState) {
              if (state is AuthenticatedState && tabState is TabInitializedState) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
                    systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark
                  ),
                  child: Stack(
                    children: <Widget>[
                      _TabLayout(
                        tabs: tabState.tabs,
                        index: tabState.index,
                      ),
                      ChangelogPopup(),
                    ],
                  ),
                );
              }

              return Scaffold(
                body: TokenLayout(
                  darkThemeTitle: null,
                  child: Center(
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TabLayout extends StatelessWidget {
  final int index;
  final List<TabEntry> tabs;

  _TabLayout({
    @required this.index,
    @required this.tabs
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: tabs.map((t) => t.widget).toList(),
        index: index,
      ),
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        currentIndex: index,
        opacity: 1,
        hasInk: true,
        inkColor: Color.fromRGBO(0, 0, 0, .15),
        onTap: (index) => BlocProvider.of<TabBloc>(context).add(SelectTabEvent(index)),
        items: tabs.map((t) =>
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
}