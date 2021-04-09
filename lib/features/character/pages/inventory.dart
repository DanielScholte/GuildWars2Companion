import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/character/bloc/character_bloc.dart';
import 'package:guildwars2_companion/features/character/models/bags.dart';
import 'package:guildwars2_companion/features/character/models/character.dart';
import 'package:guildwars2_companion/features/item/enums/item_section.dart';
import 'package:guildwars2_companion/features/item/models/inventory.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';

class InventoryPage extends StatelessWidget {
  final Character _character;

  InventoryPage(this._character);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.indigo,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Inventory',
          color: Colors.indigo,
        ),
        body: BlocConsumer<CharacterBloc, CharacterState>(
          listenWhen: (previous, current) => current is ErrorCharactersState,
          listener: (context, state) => Navigator.of(context).pop(),
          builder: (context, state) {
            if (state is ErrorCharactersState) {
              return Center(
                child: CompanionError(
                  title: 'the character',
                  onTryAgain: () =>
                    BlocProvider.of<CharacterBloc>(context).add(RefreshCharacterDetailsEvent()),
                ),
              );
            }

            if (state is LoadedCharactersState && state.detailsError) {
              return Center(
                child: CompanionError(
                  title: 'the character items',
                  onTryAgain: () =>
                    BlocProvider.of<CharacterBloc>(context).add(LoadCharacterDetailsEvent()),
                ),
              );
            }

            if (state is LoadedCharactersState && state.detailsLoaded) {
              Character character = state.characters.firstWhere((c) => c.name == _character.name);

              if (character == null) {
                return Center(
                  child: CompanionError(
                    title: 'the character',
                    onTryAgain: () =>
                      BlocProvider.of<CharacterBloc>(context).add(RefreshCharacterDetailsEvent()),
                  ),
                );
              }

              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<CharacterBloc>(context).add(RefreshCharacterDetailsEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: character.bags
                    .map((b) => _InventoryBag(
                      bag: b,
                      index: character.bags.indexOf(b)
                    ))
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

class _InventoryBag extends StatelessWidget {
  final Bags bag;
  final int index;

  _InventoryBag({
    @required this.bag,
    @required this.index
  });

  @override
  Widget build(BuildContext context) {
    List<InventoryItem> inventory = bag.inventory.where((i) => i.id != -1 && i.itemInfo != null).toList();

    return CompanionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                if (bag.itemInfo != null)
                  ItemBox(
                    item: bag.itemInfo,
                    hero: '$index ${bag.id}',
                    size: 45.0,
                    includeMargin: false,
                    section: ItemSection.INVENTORY,
                  ),
                if (bag.itemInfo != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        bag.itemInfo.name,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w500
                        )
                      ),
                    ),
                  ),
                if (bag.itemInfo == null)
                  Spacer(),
                Text(
                  '${inventory.length}/${bag.size}',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontStyle: inventory.length == bag.size ? FontStyle.italic : FontStyle.normal
                  ),
                )
              ],
            ),
          ),
          if (inventory.length > 0)
            Divider(
              height: 2,
              thickness: 1
            ),
          if (inventory.length > 0)
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children: inventory
                    .where((i) => i.id != -1)
                    .map((i) =>
                    ItemBox(
                      item: i.itemInfo,
                      skin: i.skinInfo,
                      hero: '$index ${inventory.indexOf(i)} ${i.id}',
                      upgradesInfo: i.upgradesInfo,
                      infusionsInfo: i.infusionsInfo,
                      quantity: i.charges != null ? i.charges : i.count,
                      includeMargin: false,
                      section: ItemSection.INVENTORY,
                    ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}