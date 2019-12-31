import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/wallet/bloc.dart';
import 'package:guildwars2_companion/models/wallet/currency.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/coin.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Wallet',
        color: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is LoadedWalletState) {
            return RefreshIndicator(
              backgroundColor: Colors.orange,
              color: Colors.white,
              onRefresh: () async {
                BlocProvider.of<WalletBloc>(context).add(LoadWalletEvent());
                await Future.delayed(Duration(milliseconds: 200), () {});
              },
              child: ListView(
                children: state.currencies.map((c) => _buildCurrencyRow(context, c)).toList(),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildCurrencyRow(BuildContext context, Currency currency) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              currency.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          _buildCurrency(context, currency),
          
        ],
      ),
    );
  }

  Widget _buildCurrency(BuildContext context, Currency currency) {
    if (currency.name == 'Coin') {
      return CompanionCoin(currency.value);
    }

    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            valueToString(currency.value),
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(left: 4.0),
            child: CachedNetworkImage(
              imageUrl: currency.icon,
              placeholder: (context, url) => Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.orange),
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  String valueToString(int value) {
    return NumberFormat('###,###', 'en').format(value);
  }
}