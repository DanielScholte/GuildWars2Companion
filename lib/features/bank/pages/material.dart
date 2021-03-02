import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/bank/bloc/bank_bloc.dart';
import 'package:guildwars2_companion/features/bank/models/material_category.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';

class MaterialBankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.deepOrange,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Materials',
          color: Colors.deepOrange,
        ),
        body: BlocBuilder<BankBloc, BankState>(
          builder: (context, state) {
            if (state is ErrorBankState) {
              return Center(
                child: CompanionError(
                  title: 'the material storage',
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
                child: CompanionListView(
                  children: state.materialCategories
                    .map((c) => _MaterialCategoryCard(category: c))
                    .toList(),
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

class _MaterialCategoryCard extends StatelessWidget {
  final MaterialCategory category;

  _MaterialCategoryCard({@required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              category.name,
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
              children: category.materials
                .map((i) => CompanionItemBox(
                  item: i.itemInfo,
                  quantity: i.count,
                  hero: '${i.id} ${category.materials.indexOf(i)}',
                  includeMargin: false,
                  section: ItemSection.MATERIAL,
                ))
                .toList(),
            ),
          ),
        ],
      ),
    );
  }
}