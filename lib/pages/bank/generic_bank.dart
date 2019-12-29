import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/bank/bloc.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';

class GenericBankPage extends StatelessWidget {

  final BankType bankType;

  GenericBankPage(this.bankType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: bankType == BankType.bank ? 'Bank' : 'Shared inventory',
        color: bankType == BankType.bank ? Colors.indigo : Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: BlocBuilder<BankBloc, BankState>(
        builder: (context, state) {
          if (state is LoadedBankState) {
            List<InventoryItem> inventory = bankType == BankType.bank 
              ? state.bank : state.inventory;

            return Theme(
              data: Theme.of(context).copyWith(
                accentColor: bankType == BankType.bank ? Colors.indigo : Colors.blue
              ),
              child: ListView(
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
    );
  }
}

enum BankType {
  bank,
  inventory
}