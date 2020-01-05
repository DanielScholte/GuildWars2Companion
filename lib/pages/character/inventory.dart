import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/bags.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/items/inventory.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/card.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';

class InventoryPage extends StatelessWidget {

  final Character _character;

  InventoryPage(this._character);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.indigo),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Inventory',
          color: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocBuilder<CharacterBloc, CharacterState>(
          builder: (context, state) {
            if (state is LoadedCharactersState && state.itemsLoaded) {
              Character character = state.characters.firstWhere((c) => c.name == _character.name);

              if (character == null) {
                return Container();
              }

              return ListView(
                children: character.bags.map((b) => _buildBag(b)).toList(),
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

  Widget _buildBag(Bags bag) {
    List<InventoryItem> inventory = bag.inventory.where((i) => i.id != -1 && i.itemInfo != null).toList();
    int usedSlots = inventory.length;
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              if (bag.itemInfo != null)
                CompanionItemBox(
                  item: bag.itemInfo,
                  size: 45.0,
                  includeMargin: false,
                ),
              if (bag.itemInfo != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      bag.itemInfo.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              if (bag.itemInfo == null)
                Spacer(),
              Text('$usedSlots/${bag.size}')
            ],
          ),
          if (usedSlots > 0)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children: inventory
                  .where((i) => i.id != -1)
                  .map((i) => CompanionItemBox(
                    item: i.itemInfo,
                    skin: i.skinInfo,
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
}