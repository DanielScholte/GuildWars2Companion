import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';
import 'package:guildwars2_companion/features/achievement/bloc/achievement_bloc.dart';
import 'package:guildwars2_companion/features/configuration/pages/configuration.dart';
import 'package:guildwars2_companion/features/dungeon/bloc/bloc.dart';
import 'package:guildwars2_companion/features/dungeon/pages/dungeons.dart';
import 'package:guildwars2_companion/features/meta_event/bloc/event_bloc.dart';
import 'package:guildwars2_companion/features/meta_event/pages/meta_events.dart';
import 'package:guildwars2_companion/features/pvp/bloc/pvp_bloc.dart';
import 'package:guildwars2_companion/features/pvp/pages/pvp.dart';
import 'package:guildwars2_companion/features/raid/bloc/raid_bloc.dart';
import 'package:guildwars2_companion/features/raid/pages/raids.dart';
import 'package:guildwars2_companion/features/wallet/bloc/bloc.dart';
import 'package:guildwars2_companion/features/wallet/pages/wallet.dart';
import 'package:guildwars2_companion/features/world_boss/bloc/bloc.dart';
import 'package:guildwars2_companion/features/world_boss/pages/world_bosses.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/core/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/info_box.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) {
        if (previous is AuthenticatedState && current is UnauthenticatedState) {
          return false;
        }

        return true;
      },
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.red : Theme.of(context).cardColor,
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
                            _buildPlaytimeBox(context),
                            if (state.tokenInfo.permissions.contains('progression'))
                              _buildMasteryLevelBox(context),
                            if (state.tokenInfo.permissions.contains('progression'))
                              _buildAchievementsBox(context, state.account.dailyAp + state.account.monthlyAp),
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
                        _buildWallet(context),
                      _buildWorldBosses(context, state.tokenInfo.permissions.contains('progression')),
                      _buildEvents(context),
                      if (state.tokenInfo.permissions.contains('pvp'))
                        _buildPvp(context),
                      _buildRaids(context, state.tokenInfo.permissions.contains('progression')),
                      _buildDungeons(context, state.tokenInfo.permissions.contains('progression'))
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

  Widget _buildMasteryLevelBox(BuildContext context) {
    return BlocBuilder<AchievementBloc, AchievementState>(
      builder: (context, state) {
        if (state is LoadedAchievementsState) {

          if (state.masteryLevel == null) {
            return CompanionInfoBox(
              header: 'Mastery level',
              text: '-',
              loading: false,
            );
          }

          return CompanionInfoBox(
            header: 'Mastery level',
            text: GuildWarsUtil.intToString(state.masteryLevel),
            loading: false,
          );
        }

        if (state is ErrorAchievementsState) {
          return CompanionInfoBox(
            header: 'Mastery level',
            loading: false,
          );
        }

        return CompanionInfoBox(
          header: 'Mastery level',
        );
      },
    );
  }

  Widget _buildAchievementsBox(BuildContext context, int dailies) {
    return BlocBuilder<AchievementBloc, AchievementState>(
      builder: (context, state) {
        if (state is LoadedAchievementsState) {
          return CompanionInfoBox(
            header: 'Achievements',
            text: GuildWarsUtil.intToString(state.achievementPoints + dailies),
            loading: false,
          );
        }

        if (state is ErrorAchievementsState) {
          return CompanionInfoBox(
            header: 'Achievements',
            loading: false,
          );
        }

        return CompanionInfoBox(
          header: 'Achievements',
        );
      },
    );
  }

  Widget _buildPlaytimeBox(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return CompanionInfoBox(
            header: 'Playtime',
            text: GuildWarsUtil.calculatePlayTime(state.account.age).toString() + 'h',
            loading: false,
          );
        }

        return CompanionInfoBox(
          header: 'Playtime',
        );
      },
    );
  }

  Widget _buildWallet(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (BuildContext context, WalletState state) {
        if (state is LoadedWalletState) {
          return CompanionButton(
            color: Colors.orange,
            title: 'Wallet',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => WalletPage())
            ),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                state.currencies.firstWhere((c) => c.name == 'Coin' || c.id == 1, orElse: null),
                state.currencies.firstWhere((c) => c.name == 'Karma' || c.id == 2, orElse: null),
                state.currencies.firstWhere((c) => c.name == 'Gem' || c.id == 4, orElse: null),
              ] .where((c) => c != null)
                .map((c) => Row(
                  children: <Widget>[
                    Container(
                      width: 20.0,
                      height: 20.0,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CompanionCachedImage(
                        imageUrl: c.icon,
                        color: Colors.white,
                        iconSize: 14,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (c.name == 'Coin' || c.id == 1)
                      Text(
                        (c.value ~/ 10000).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if ((c.name == 'Karma' || c.id == 2) && c.value < 1000000)
                      Text(
                        (c.value ~/ 1000).toString() + 'k',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if ((c.name == 'Karma' || c.id == 2) && c.value >= 1000000 && c.value < 10000000)
                      Text(
                        (c.value / 1000000).toStringAsFixed(1) + 'm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if ((c.name == 'Karma' || c.id == 2) && c.value >= 10000000)
                      Text(
                        (c.value ~/ 1000000).toString() + 'm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if (c.name == 'Gem' || c.id == 4)
                      Text(
                        c.value.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                  ],
                ))
                .toList(),
            ),
          );
        }

        if (state is ErrorWalletState) {
          return CompanionButton(
            color: Colors.orange,
            title: 'Wallet',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => WalletPage())
            ),
            leading: Icon(
              FontAwesomeIcons.dizzy,
              size: 35.0,
              color: Colors.white,
            ),
          );
        }

        return CompanionButton(
          color: Colors.orange,
          title: 'Wallet',
          onTap: null,
          loading: true,
        );
      },
    );
  }

  Widget _buildPvp(BuildContext context) {
    return CompanionButton(
      color: Color(0xFF678A9E),
      title: 'PvP',
      onTap: () {
        if (!(BlocProvider.of<PvpBloc>(context).state is LoadedPvpState)) {
          BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent());
        }
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PvpPage()
        ));
      },
      leading: Image.asset('assets/button_headers/pvp.jpg'),
    );
  }

  Widget _buildWorldBosses(BuildContext context, bool includeProgress) {
    return CompanionButton(
      color: Colors.deepPurple,
      title: 'World bosses',
      onTap: () {
        BlocProvider.of<WorldBossBloc>(context).add(LoadWorldbossesEvent(true, includeProgress));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorldBossesPage()
        ));
      },
      leading: Image.asset('assets/button_headers/world_bosses.jpg'),
    );
  }

  Widget _buildEvents(BuildContext context) {
    return CompanionButton(
      color: Colors.green,
      title: 'Meta Events',
      onTap: () {
        BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent());
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MetaEventsPage()
        ));
      },
      leading: Image.asset('assets/button_headers/events.jpg'),
    );
  }

  Widget _buildDungeons(BuildContext context, bool includeProgress) {
    return CompanionButton(
      color: Colors.deepOrange,
      title: 'Dungeons',
      onTap: () {
        BlocProvider.of<DungeonBloc>(context).add(LoadDungeonsEvent(includeProgress));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DungeonsPage()
        ));
      },
      leading: Image.asset('assets/button_headers/dungeons.jpg'),
    );
  }

  Widget _buildRaids(BuildContext context, bool includeProgress) {
    return CompanionButton(
      color: Colors.blue,
      title: 'Raids',
      onTap: () {
        BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(includeProgress));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RaidsPage()
        ));
      },
      leading: Image.asset('assets/button_headers/raids.jpg'),
    );
  }
}
