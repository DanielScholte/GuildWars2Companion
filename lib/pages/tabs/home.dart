import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/pages/home/wallet_page.dart';
import 'package:guildwars2_companion/pages/home/world_bosses.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';
import 'package:guildwars2_companion/widgets/info_box.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      condition: (previous, current) => current is AuthenticatedState,
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0))
                ),
                margin: EdgeInsets.only(bottom: 16.0),
                width: double.infinity,
                child: SafeArea(
                  minimum: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      _buildAccountHeader(state.account.name),
                      Container(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          runSpacing: 16.0,
                          children: <Widget>[
                            _buildPlaytimeBox(context),
                            if (state.tokenInfo.permissions.contains('progression'))
                              CompanionInfoBox(
                                header: 'Mastery level',
                                text: '298?',
                                loading: false,
                              ),
                            if (state.tokenInfo.permissions.contains('progression'))
                              CompanionInfoBox(
                                header: 'Achievements',
                                text: '30.000?',
                                loading: false,
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Expanded(
                  child: ListView(
                    children: <Widget>[
                      if (state.tokenInfo.permissions.contains('wallet'))
                        _buildWallet(context),
                      _buildWorldBosses(context),
                      _buildRaids()
                    ],
                  ),
                ),
              )
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _buildAccountHeader(String accountName) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: RichText(
        text: TextSpan(
          text: 'Welcome ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w300
          ),
          children: [
            TextSpan(
              text: accountName,
              style: TextStyle(
                fontWeight: FontWeight.w400
              )
            ),
          ],
        ),
      ),
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
          return CompanionFullButton(
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                    if (c.name == 'Karma' && c.value >= 1000000)
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

        return CompanionFullButton(
          color: Colors.orange,
          title: 'Wallet',
          onTap: null,
          loading: true,
        );
      },
    );
  }

  Widget _buildWorldBosses(BuildContext context) {
    return CompanionFullButton(
      color: Colors.deepPurple,
      title: 'World bosses',
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WorldBossesPage()
      )),
      leading: Image.asset('assets/button_headers/world_bosses.jpg'),
    );
  }

  Widget _buildRaids() {
    return CompanionFullButton(
      color: Colors.blue,
      title: 'Raids',
      onTap: () {},
      leading: Image.asset('assets/button_headers/raids.jpg'),
    );
  }
}