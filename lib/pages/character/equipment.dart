import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/equipment.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

import '../../models/character/equipment.dart';

class EquipmentPage extends StatelessWidget {
  final Character _character;
  final EquipmentTab _equipmentTab;
  final bool singular;

  EquipmentPage(this._character, this._equipmentTab, {this.singular = false});

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: singular ? Colors.teal : _character.professionColor,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: _equipmentTab.name != null && _equipmentTab.name.isNotEmpty ? _equipmentTab.name : 'Nameless equipment build',
          color: singular ? Colors.teal : _character.professionColor,
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

            if ((state is LoadedCharactersState && state.detailsError)) {
              return Center(
                child: CompanionError(
                  title: 'the character builds',
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

              return CompanionListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildGear(),
                        _buildAccessories()
                      ],
                    ),
                  )
                ],
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

  Widget _buildGear() {
    return Column(
      children: <Widget>[
        _buildSlot(_getEquipmentPiece('Helm')),
        _buildSlot(_getEquipmentPiece('Shoulders')),
        _buildSlot(_getEquipmentPiece('Coat')),
        _buildSlot(_getEquipmentPiece('Gloves')),
        _buildSlot(_getEquipmentPiece('Leggings')),
        _buildSlot(_getEquipmentPiece('Boots')),
        Container(height: 16.0,),
        _buildSlot(_getEquipmentPiece('WeaponA1')),
        _buildSlot(_getEquipmentPiece('WeaponA2'), small: true),
        Container(height: 16.0,),
        _buildSlot(_getEquipmentPiece('WeaponB1')),
        _buildSlot(_getEquipmentPiece('WeaponB2'), small: true),
      ],
    );
  }

  Widget _buildAccessories() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildSlot(_getEquipmentPiece('Backpack')),
            _buildSlot(_getEquipmentPiece('Accessory1')),
            _buildSlot(_getEquipmentPiece('Accessory2')),
          ],
        ),
        Row(
          children: <Widget>[
            _buildSlot(_getEquipmentPiece('Amulet')),
            _buildSlot(_getEquipmentPiece('Ring1')),
            _buildSlot(_getEquipmentPiece('Ring2')),
          ],
        ),
        Container(height: 16.0,),
        Row(
          children: <Widget>[
            _buildSlot(_getEquipmentPiece('Sickle')),
            _buildSlot(_getEquipmentPiece('Axe')),
            _buildSlot(_getEquipmentPiece('Pick')),
          ],
        ),
        Container(height: 16.0,),
        Row(
          children: <Widget>[
            _buildSlot(_getEquipmentPiece('HelmAquatic')),
            _buildSlot(_getEquipmentPiece('WeaponAquaticA')),
            _buildSlot(_getEquipmentPiece('WeaponAquaticB')),
          ],
        ),
      ],
    );
  }

  Equipment _getEquipmentPiece(String name) {
    Equipment equipment = _equipmentTab.equipment.firstWhere(
      (e) => e.slot == name,
      orElse: () => null
    );

    if (['Sickle', 'Axe', 'Pick'].contains(name)) {
      if (equipment == null) {
        return _character.equipment.firstWhere(
          (e) => e.slot == name,
          orElse: () => null
        );
      }

      return equipment;
    }

    if (equipment != null && equipment.itemInfo != null && equipment.itemInfo.rarity != "Legendary") { 
      // Due to current legendary equipmenttab bug.
      // Grab the correct index. Important when using two of the same weapon, like two identical daggers with different upgrades.
      // Wrapped in a try catch to prevent potential errors, and use the equipment without upgrades instead.
      try {
        int index = _equipmentTab.equipment
          .where((e) => e.id == equipment.id && e.skin == equipment.skin)
          .toList()
          .indexOf(equipment);
      
        List<Equipment> alternatives = _character.equipment
          .where((e) => e.id == equipment.id
            && e.skin == equipment.skin
            && e.tabs != null
            && e.tabs.contains(_equipmentTab.tab))
          .toList();

        if (alternatives.length >= index + 1) {
          Equipment alternative = alternatives[index];

          alternative.slot = name;

          return alternative;
        }
      } catch (_) {}
    }

    return equipment;
  }

  Widget _buildSlot(Equipment equipment, { bool small = false }) {
    if (equipment ==  null) {
      return CompanionItemBox(
        size: small ? 45.0 : 55.0,
        item: null,
        displayEmpty: true,
        includeMargin: true,
      );
    }

    return CompanionItemBox(
      size: small ? 45.0 : 55.0,
      item: equipment.itemInfo,
      skin: equipment.skinInfo,
      hero: '${equipment.slot}${equipment.id}',
      upgradesInfo: equipment.upgradesInfo,
      infusionsInfo: equipment.infusionsInfo,
      includeMargin: true,
    );
  }
}