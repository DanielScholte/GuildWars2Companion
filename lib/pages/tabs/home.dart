import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/pages/wallet_page.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildPlaytimeBox(context),
                          if (state.tokenInfo.permissions.contains('progression'))
                            _buildHeaderInfoBox(context, "Mastery level", "298?", false),
                          if (state.tokenInfo.permissions.contains('progression'))
                            _buildHeaderInfoBox(context, "Achievements", "30.000?", false),
                        ],
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
                      _buildWorldBosses(),
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
          return _buildHeaderInfoBox(context, 'Playtime', GuildWarsUtil.calculatePlayTime(state.account.age).toString() + 'h', false);
        }

        return _buildHeaderInfoBox(context, 'Playtime', '?', true);
      },
    );
  }

  Widget _buildHeaderInfoBox(BuildContext context, String header, String text, bool loading) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      height: 80.0,
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0
            ),
            textAlign: TextAlign.center,
          ),
          if (loading)
            Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                width: 22.0,
                height: 22.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                )
              ),
            ),
          if (!loading)
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600
              ),
            ),
        ],
      ),
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
                        (c.value / 10000).round().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if (c.name == 'Karma' && c.value < 1000000)
                      Text(
                        (c.value / 1000).round().toString() + 'k',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if (c.name == 'Karma' && c.value >= 1000000)
                      Text(
                        (c.value / 1000000).round().toString() + 'm',
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

  Widget _buildWorldBosses() {
    return CompanionFullButton(
      color: Colors.deepPurple,
      title: 'World Bosses',
      onTap: () {},
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