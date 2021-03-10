import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/features/wallet/bloc/bloc.dart';
import 'package:guildwars2_companion/features/wallet/pages/wallet.dart';

class WalletButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}