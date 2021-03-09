import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/character/bloc/character_bloc.dart';
import 'package:guildwars2_companion/features/character/models/character.dart';
import 'package:guildwars2_companion/features/character/models/equipment.dart';
import 'package:guildwars2_companion/features/item/models/item.dart';
import 'package:guildwars2_companion/features/item/widgets/item_box.dart';

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
        _EquipmentSlot(_getEquipmentPiece('Helm')),
        _EquipmentSlot(_getEquipmentPiece('Shoulders')),
        _EquipmentSlot(_getEquipmentPiece('Coat')),
        _EquipmentSlot(_getEquipmentPiece('Gloves')),
        _EquipmentSlot(_getEquipmentPiece('Leggings')),
        _EquipmentSlot(_getEquipmentPiece('Boots')),
        Container(height: 16.0,),
        _EquipmentSlot(_getEquipmentPiece('WeaponA1')),
        _EquipmentSlot(_getEquipmentPiece('WeaponA2'), small: true),
        Container(height: 16.0,),
        _EquipmentSlot(_getEquipmentPiece('WeaponB1')),
        _EquipmentSlot(_getEquipmentPiece('WeaponB2'), small: true),
      ],
    );
  }

  Widget _buildAccessories() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _EquipmentSlot(_getEquipmentPiece('Backpack')),
            _EquipmentSlot(_getEquipmentPiece('Accessory1')),
            _EquipmentSlot(_getEquipmentPiece('Accessory2')),
          ],
        ),
        Row(
          children: <Widget>[
            _EquipmentSlot(_getEquipmentPiece('Amulet')),
            _EquipmentSlot(_getEquipmentPiece('Ring1')),
            _EquipmentSlot(_getEquipmentPiece('Ring2')),
          ],
        ),
        Container(height: 16.0,),
        Row(
          children: <Widget>[
            _EquipmentSlot(_getEquipmentPiece('Sickle')),
            _EquipmentSlot(_getEquipmentPiece('Axe')),
            _EquipmentSlot(_getEquipmentPiece('Pick')),
          ],
        ),
        Container(height: 16.0,),
        Row(
          children: <Widget>[
            _EquipmentSlot(_getEquipmentPiece('HelmAquatic')),
            _EquipmentSlot(_getEquipmentPiece('WeaponAquaticA')),
            _EquipmentSlot(_getEquipmentPiece('WeaponAquaticB')),
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
}

class _EquipmentSlot extends StatelessWidget {
  final Equipment _equipment;
  final bool small;

  _EquipmentSlot(
    this._equipment,
    {
      this.small = false
    }
  );

  @override
  Widget build(BuildContext context) {
    if (_equipment ==  null) {
      return CompanionItemBox(
        size: small ? 45.0 : 55.0,
        item: null,
        displayEmpty: true,
        includeMargin: true,
        section: ItemSection.EQUIPMENT,
      );
    }

    return CompanionItemBox(
      size: small ? 45.0 : 55.0,
      item: _equipment.itemInfo,
      skin: _equipment.skinInfo,
      hero: '${_equipment.slot}${_equipment.id}',
      upgradesInfo: _equipment.upgradesInfo,
      infusionsInfo: _equipment.infusionsInfo,
      includeMargin: true,
      section: ItemSection.EQUIPMENT,
    );
  }
}