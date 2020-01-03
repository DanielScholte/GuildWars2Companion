import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/pages/bank/generic_bank.dart';
import 'package:guildwars2_companion/pages/bank/material.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class BankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Bank',
        color: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: BlocBuilder<BankBloc, BankState>(
        builder: (context, state) {
          if (state is LoadedBankState) {
            return ListView(
              children: <Widget>[
                CompanionFullButton(
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GenericBankPage(BankType.bank),
                    ));
                  },
                  title: 'Bank',
                  leading: Icon(
                    GuildWarsIcons.inventory,
                    size: 48.0,
                    color: Colors.white,
                  ),
                ),
                CompanionFullButton(
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MaterialPage(),
                    ));
                  },
                  title: 'Materials',
                  leading: Icon(
                    FontAwesomeIcons.th,
                    size: 48.0,
                    color: Colors.white,
                  ),
                ),
                CompanionFullButton(
                  color: Colors.blue,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GenericBankPage(BankType.inventory),
                    ));
                  },
                  title: 'Shared inventory',
                  leading: Icon(
                    GuildWarsIcons.inventory,
                    size: 48.0,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}