import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/achievement_bloc.dart';
import 'package:guildwars2_companion/blocs/achievement/achievement_state.dart';
import 'package:guildwars2_companion/blocs/dungeon/bloc.dart';
import 'package:guildwars2_companion/blocs/raid/raid_bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/blocs/world_boss/bloc.dart';
import 'package:guildwars2_companion/pages/home/dungeons.dart';
import 'package:guildwars2_companion/pages/home/raids.dart';
import 'package:guildwars2_companion/pages/home/wallet.dart';
import 'package:guildwars2_companion/pages/home/world_bosses.dart';
import 'package:guildwars2_companion/pages/info.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/header.dart';
import 'package:guildwars2_companion/widgets/info_box.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      condition: (previous, current) {
        if (previous is AuthenticatedState && current is UnauthenticatedState) {
          return false;
        }

        return true;
      },
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
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
                    FontAwesomeIcons.infoCircle,
                    size: 20.0,
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InfoPage()
                  )),
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 20.0,
                  ),
                  onPressed: () => BlocProvider.of<AccountBloc>(context).add(UnauthenticateEvent()),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                CompanionHeader(
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
                MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 8.0),
                      children: <Widget>[
                        if (state.tokenInfo.permissions.contains('wallet'))
                          _buildWallet(context),
                        _buildWorldBosses(context, state.tokenInfo.permissions.contains('progression')),
                        _buildRaids(context, state.tokenInfo.permissions.contains('progression')),
                        _buildDungeons(context, state.tokenInfo.permissions.contains('progression'))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: CompanionError(
              title: 'the account',
              onTryAgain: () async =>
                BlocProvider.of<AccountBloc>(context).add(AuthenticateEvent(await TokenUtil.getToken())),
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
          return CompanionInfoBox(
            header: 'Mastery level',
            text: GuildWarsUtil.intToString(state.masteryLevel),
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
                state.currencies.firstWhere((c) => c.name == 'Coin', orElse: null),
                state.currencies.firstWhere((c) => c.name == 'Karma', orElse: null),
                state.currencies.firstWhere((c) => c.name == 'Gem', orElse: null),
              ] .where((c) => c != null)
                .map((c) => Row(
                  children: <Widget>[
                    Container(
                      width: 20.0,
                      height: 20.0,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: c.icon,
                        placeholder: (context, url) => Theme(
                          data: Theme.of(context).copyWith(accentColor: Colors.white),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Center(child: Icon(
                        FontAwesomeIcons.dizzy,
                        size: 14,
                        color: Colors.white,
                      )),
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (c.name == 'Coin')
                      Text(
                        (c.value ~/ 10000).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if (c.name == 'Karma' && c.value < 1000000)
                      Text(
                        (c.value ~/ 1000).toString() + 'k',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if (c.name == 'Karma' && c.value >= 1000000 && c.value < 10000000)
                      Text(
                        (c.value / 1000000).toStringAsFixed(1) + 'm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if (c.name == 'Karma' && c.value >= 10000000)
                      Text(
                        (c.value ~/ 1000000).toString() + 'm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if (c.name == 'Gem')
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

        return CompanionButton(
          color: Colors.orange,
          title: 'Wallet',
          onTap: null,
          loading: true,
        );
      },
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
