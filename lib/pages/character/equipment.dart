import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/equipment.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/item_box.dart';

class EquipmentPage extends StatelessWidget {
  final Character _character;

  EquipmentPage(this._character);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.teal),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Equipment',
          color: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        body: BlocListener<CharacterBloc, CharacterState>(
          condition: (previous, current) => current is ErrorCharactersState,
          listener: (context, state) => Navigator.of(context).pop(),
          child: BlocBuilder<CharacterBloc, CharacterState>(
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
                    title: 'the character items',
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
                  color: Colors.white,
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
                            _buildGear(character.equipment),
                            _buildAccessories(character.equipment)
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
      ),
    );
  }

  Widget _buildGear(List<Equipment> equipment) {
    return Column(
      children: <Widget>[
        _buildSlot(equipment.firstWhere((e) => e.slot == 'Helm', orElse: () => null)),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'Shoulders', orElse: () => null)),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'Coat', orElse: () => null)),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'Gloves', orElse: () => null)),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'Leggings', orElse: () => null)),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'Boots', orElse: () => null)),
        Container(height: 16.0,),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'WeaponA1', orElse: () => null)),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'WeaponA2', orElse: () => null), small: true),
        Container(height: 16.0,),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'WeaponB1', orElse: () => null)),
        _buildSlot(equipment.firstWhere((e) => e.slot == 'WeaponB2', orElse: () => null), small: true),
      ],
    );
  }

  Widget _buildAccessories(List<Equipment> equipment) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Backpack', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Accessory1', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Accessory2', orElse: () => null)),
          ],
        ),
        Row(
          children: <Widget>[
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Amulet', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Ring1', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Ring2', orElse: () => null)),
          ],
        ),
        Container(height: 16.0,),
        Row(
          children: <Widget>[
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Sickle', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Axe', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'Pick', orElse: () => null)),
          ],
        ),
        Container(height: 16.0,),
        Row(
          children: <Widget>[
            _buildSlot(equipment.firstWhere((e) => e.slot == 'HelmAquatic', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'WeaponAquaticA', orElse: () => null)),
            _buildSlot(equipment.firstWhere((e) => e.slot == 'WeaponAquaticB', orElse: () => null)),
          ],
        ),
      ],
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
      hero: equipment.slot,
      upgradesInfo: equipment.upgradesInfo,
      infusionsInfo: equipment.infusionsInfo,
      includeMargin: true,
    );
  }
}