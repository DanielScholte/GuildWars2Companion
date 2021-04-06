import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/bank/bloc/bank_bloc.dart';
import 'package:guildwars2_companion/features/item/enums/item_section.dart';
import 'package:guildwars2_companion/features/item/models/inventory.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';

enum BankType {
  BANK,
  INVENTORY
}

class GenericBankPage extends StatelessWidget {
  final BankType bankType;

  GenericBankPage(this.bankType);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: bankType == BankType.BANK ? Colors.green : Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: bankType == BankType.BANK ? 'Bank' : 'Shared inventory',
          color: bankType == BankType.BANK ? Colors.green : Colors.blue,
        ),
        body: BlocBuilder<BankBloc, BankState>(
          builder: (context, state) {
            if (state is ErrorBankState) {
              return Center(
                child: CompanionError(
                  title: bankType == BankType.BANK ? 'the bank' : 'the shared inventory',
                  onTryAgain: () =>
                    BlocProvider.of<BankBloc>(context).add(LoadBankEvent()),
                ),
              );
            }

            if (state is LoadedBankState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<BankBloc>(context).add(LoadBankEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: bankType == BankType.BANK
                  ? _BankListView(inventory: state.bank)
                  : _SharedInventoryListView(inventory: state.inventory),
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

class _BankListView extends StatelessWidget {
  final List<InventoryItem> inventory;

  _BankListView({@required this.inventory});

  @override
  Widget build(BuildContext context) {
    return CompanionListView(
      children: Iterable
        .generate((inventory.length / 30).ceil())
        .map((index) {
          List<InventoryItem> bankTab = inventory
            .skip(index * 30)
            .take(30)
            .toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "${bankTab.where((i) => i.id != -1).length} / ${bankTab.length} slots",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: bankTab
                      .map((i) {
                        if (i.id == -1) {
                          return ItemBox(
                            item: null,
                            displayEmpty: true,
                            includeMargin: false,
                          );
                        }

                        return ItemBox(
                          item: i.itemInfo,
                          skin: i.skinInfo,
                          hero: '${inventory.indexOf(i)}${i.id}',
                          upgradesInfo: i.upgradesInfo,
                          infusionsInfo: i.infusionsInfo,
                          quantity: i.charges != null ? i.charges : i.count,
                          includeMargin: false,
                          section: ItemSection.BANK,
                        );
                      })
                      .toList(),
                  ),
                ),
              ],
            ),
          );
        })
        .toList()
    );
  }
}

class _SharedInventoryListView extends StatelessWidget {
  final List<InventoryItem> inventory;

  _SharedInventoryListView({@required this.inventory});

  @override
  Widget build(BuildContext context) {
    return CompanionListView(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 4.0,
            runSpacing: 4.0,
            children: inventory
              .where((i) => i.id != -1)
              .map((i) => ItemBox(
                item: i.itemInfo,
                skin: i.skinInfo,
                hero: '${inventory.indexOf(i)}${i.id}',
                upgradesInfo: i.upgradesInfo,
                infusionsInfo: i.infusionsInfo,
                quantity: i.charges != null ? i.charges : i.count,
                includeMargin: false,
                section: ItemSection.BANK,
              ))
              .toList(),
          ),
        ),
      ]
    );
  }
}