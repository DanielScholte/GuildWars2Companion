import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class GenericBankPage extends StatelessWidget {

  final BankType bankType;

  GenericBankPage(this.bankType);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: bankType == BankType.bank ? Colors.green : Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: bankType == BankType.bank ? 'Bank' : 'Shared inventory',
          color: bankType == BankType.bank ? Colors.green : Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<BankBloc, BankState>(
          builder: (context, state) {
            if (state is ErrorBankState) {
              return Center(
                child: CompanionError(
                  title: bankType == BankType.bank ? 'the bank' : 'the shared inventory',
                  onTryAgain: () =>
                    BlocProvider.of<BankBloc>(context).add(LoadBankEvent()),
                ),
              );
            }

            if (state is LoadedBankState) {
              List<InventoryItem> inventory = bankType == BankType.bank 
                ? state.bank : state.inventory;
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<BankBloc>(context).add(LoadBankEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: inventory
                          .where((i) => i.id != -1)
                          .map((i) => CompanionItemBox(
                            item: i.itemInfo,
                            skin: i.skinInfo,
                            hero: '${inventory.indexOf(i)}${i.id}',
                            upgradesInfo: i.upgradesInfo,
                            infusionsInfo: i.infusionsInfo,
                            quantity: i.charges != null ? i.charges : i.count,
                            includeMargin: false,
                          ))
                          .toList(),
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

enum BankType {
  bank,
  inventory
}