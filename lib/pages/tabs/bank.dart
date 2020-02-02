import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/pages/bank/generic_bank.dart';
import 'package:guildwars2_companion/pages/bank/material.dart';
import 'package:guildwars2_companion/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';

class BankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.indigo),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Bank',
          color: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<BankBloc, BankState>(
          builder: (context, state) {
            if (state is ErrorBankState) {
              return Center(
                child: CompanionError(
                  title: 'the bank',
                  onTryAgain: () =>
                    BlocProvider.of<BankBloc>(context).add(LoadBankEvent()),
                ),
              );
            }

            if (state is LoadedBankState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Colors.white,
                onRefresh: () async {
                  BlocProvider.of<BankBloc>(context).add(LoadBankEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: ListView(
                  children: <Widget>[
                    CompanionButton(
                      color: Colors.blueGrey,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GenericBankPage(BankType.bank),
                        ));
                      },
                      title: 'Bank',
                      leading: Icon(
                        FontAwesomeIcons.archive,
                        size: 42.0,
                        color: Colors.white,
                      ),
                    ),
                    CompanionButton(
                      color: Colors.deepOrange,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MaterialPage(),
                        ));
                      },
                      title: 'Materials',
                      leading: Icon(
                        FontAwesomeIcons.th,
                        size: 42.0,
                        color: Colors.white,
                      ),
                    ),
                    CompanionButton(
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
}
