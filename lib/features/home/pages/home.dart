import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';
import 'package:guildwars2_companion/features/achievement/widgets/info_box.dart';
import 'package:guildwars2_companion/features/configuration/pages/configuration.dart';
import 'package:guildwars2_companion/features/dungeon/widgets/button.dart';
import 'package:guildwars2_companion/features/home/widgets/playtime_info_box.dart';
import 'package:guildwars2_companion/features/mastery/widgets/info_box.dart';
import 'package:guildwars2_companion/features/meta_event/widgets/button.dart';
import 'package:guildwars2_companion/features/pvp/bloc/pvp_bloc.dart';
import 'package:guildwars2_companion/features/pvp/widgets/button.dart';
import 'package:guildwars2_companion/features/raid/widgets/button.dart';
import 'package:guildwars2_companion/features/tabs/bloc/tab_bloc.dart';
import 'package:guildwars2_companion/features/wallet/widgets/button.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/world_boss/widgets/button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (_, current) => current is AuthenticatedState,
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.red : Theme.of(context).cardColor,
              brightness: Brightness.dark,
              centerTitle: true,
              elevation: 0.0,
              title: RichText(
                text: TextSpan(
                  text: 'Welcome ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300
                  ),
                  children: [
                    TextSpan(
                      text: state.account.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400
                      )
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.cog,
                    size: 20.0,
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ConfigurationPage()
                  )),
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 20.0,
                  ),
                  onPressed: () {
                    BlocProvider.of<PvpBloc>(context).add(ResetPvpEvent());
                    BlocProvider.of<TabBloc>(context).add(ResetTabsEvent());
                    BlocProvider.of<AccountBloc>(context).add(UnauthenticateEvent());
                  }
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                CompanionHeader(
                  color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          runSpacing: 16.0,
                          children: <Widget>[
                            PlaytimeInfoBox(),
                            if (state.tokenInfo.permissions.contains('progression'))
                              MasteryInfoBox(),
                            if (state.tokenInfo.permissions.contains('progression'))
                              AchievementInfoBox(account: state.account)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: CompanionListView(
                    children: <Widget>[
                      if (state.tokenInfo.permissions.contains('wallet'))
                        WalletButton(),
                      WorldBossButton(hasPermission: state.tokenInfo.permissions.contains('progression')),
                      MetaEventButton(),
                      if (state.tokenInfo.permissions.contains('pvp'))
                        PvpButton(),
                      RaidButton(hasPermission: state.tokenInfo.permissions.contains('progression')),
                      DungeonButton(hasPermission: state.tokenInfo.permissions.contains('progression'))
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: CompanionError(
              title: 'the account',
              onTryAgain: () async =>
                BlocProvider.of<AccountBloc>(context).add(SetupAccountEvent()),
            ),
          ),
        );
      },
    );
  }
}
