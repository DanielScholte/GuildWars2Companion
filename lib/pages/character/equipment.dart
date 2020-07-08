import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/equipment.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';

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
          title: _equipmentTab.name != null && _equipmentTab.name.isNotEmpty ? _equipmentTab.name : 'Unnamed equipment build',
          color: singular ? Colors.teal : _character.professionColor,
          foregroundColor: Colors.white,
          elevation: 4.0,
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
                    BlocProvider.of<CharacterBloc>(context).add(RefreshCharacterItemsEvent()),
                ),
              );
            }

            if ((state is LoadedCharactersState && state.hasError)) {
              return Center(
                child: CompanionError(
                  title: 'the character builds',
                  onTryAgain: () =>
                    BlocProvider.of<CharacterBloc>(context).add(LoadCharacterItemsEvent(state.characters)),
                ),
              );
            }

            if (state is LoadedCharactersState && state.itemsLoaded) {
              Character character = state.characters.firstWhere((c) => c.name == _character.name);

              if (character == null) {
                return Center(
                  child: CompanionError(
                    title: 'the character',
                    onTryAgain: () =>
                      BlocProvider.of<CharacterBloc>(context).add(RefreshCharacterItemsEvent()),
                  ),
                );
              }

              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<CharacterBloc>(context).add(RefreshCharacterItemsEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: ListView(
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
    return _equipmentTab.equipment.firstWhere(
      (e) => e.slot == name,
      orElse: () => _character.equipment.firstWhere(
        (e) => e.slot == name,
        orElse: () => null)
    );
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