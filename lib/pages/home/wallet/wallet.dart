import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/coin.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.orange,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Wallet',
          color: Colors.orange,
        ),
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is ErrorWalletState) {
              return Center(
                child: CompanionError(
                  title: 'the wallet',
                  onTryAgain: () =>
                    BlocProvider.of<WalletBloc>(context).add(LoadWalletEvent()),
                ),
              );
            }

            if (state is LoadedWalletState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<WalletBloc>(context).add(LoadWalletEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: List.generate(state.currencies.length, (index) => _buildCurrencyRow(context, index, state.currencies[index])),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrencyRow(BuildContext context, int index, Currency currency) {
    Color highlightColor = Theme.of(context).brightness ==  Brightness.light ? Colors.black12 : Colors.white12;
    return Container(
      padding: EdgeInsets.all(8.0),
      color: index % 2 != 0 ? highlightColor : null,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              currency.name,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.w500
              )
            ),
          ),
          _buildCurrency(context, currency),
        ],
      ),
    );
  }

  Widget _buildCurrency(BuildContext context, Currency currency) {
    if (currency.name == 'Coin' || currency.id == 1) {
      return Padding(
        padding: EdgeInsets.only(right: 2.0),
        child: CompanionCoin(
          currency.value,
          innerPadding: 6.0,
          color: Theme.of(context).textTheme.bodyText1.color
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            GuildWarsUtil.intToString(currency.value),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(left: 8.0),
            child: CompanionCachedImage(
              imageUrl: currency.icon,
              color: Colors.orange,
              iconSize: 14,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}