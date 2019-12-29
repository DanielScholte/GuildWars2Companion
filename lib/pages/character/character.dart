import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/account/bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/models/character/crafting.dart';
import 'package:guildwars2_companion/pages/character/equipment.dart';
import 'package:guildwars2_companion/pages/character/inventory.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';
import 'package:guildwars2_companion/widgets/info_box.dart';

class CharacterPage extends StatelessWidget {

  final Character _character;

  CharacterPage(this._character);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: _character.name,
        color: _character.professionColor,
        foregroundColor: Colors.white,
        icon: Container(
          width: 28,
          height: 28,
          child: ColorFiltered(
            child: CachedNetworkImage(
              imageUrl: _character.professionInfo.iconBig,
              placeholder: (context, url) => Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.contain,
            ),
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          ),
        ),
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (BuildContext context, CharacterState state) {
          if (state is LoadedCharactersState) {
            Character character = state.characters.firstWhere((c) => c.name == _character.name);

            if (character == null) {
              return Container();
            }

            return Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: character.professionColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 8.0,
                      ),
                    ],
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0))
                  ),
                  margin: EdgeInsets.only(bottom: 16.0),
                  width: double.infinity,
                  child: SafeArea(
                    minimum: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            runSpacing: 16.0,
                            children: <Widget>[
                              CompanionInfoBox(
                                header: 'Level',
                                text: character.level.toString(),
                                loading: false,
                              ),
                              CompanionInfoBox(
                                header: 'Playtime',
                                text: GuildWarsUtil.calculatePlayTime(character.age).toString() + 'h',
                                loading: false,
                              ),
                              CompanionInfoBox(
                                header: 'Deaths',
                                text: character.deaths.toString(),
                                loading: false,
                              ),
                            ],
                          ),
                        ),
                        if (character.crafting != null && character.crafting.isNotEmpty)
                          _buildCrafting(character.crafting)
                      ],
                    ),
                  ),
                ),
                _buildButtons(context, state)
              ],
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildCrafting(List<Crafting> crafting) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.only(top: 4.0),
      child: Column(
        children: <Widget>[
          Text(
            'Crafting disciplines',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: crafting
              .where((c) => GuildWarsUtil.validDisciplines().contains(c.discipline))
              .map((c) => Padding(
                padding: EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset('assets/crafting/${c.discipline.toLowerCase()}.png'),
                    Text(
                      c.rating.toString(),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ))
              .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, LoadedCharactersState characterState) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(accentColor: _character.professionColor),
                child: ListView(
                  children: <Widget>[
                    if (state.tokenInfo.permissions.contains('inventories')
                      && state.tokenInfo.permissions.contains('builds'))
                      CompanionFullButton(
                        color: Colors.teal,
                        onTap: () {
                          if (!characterState.itemsLoaded && !characterState.itemsLoading) {
                            BlocProvider.of<CharacterBloc>(context).add(LoadCharacterItemsEvent(characterState.characters));
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EquipmentPage(_character),
                          ));
                        },
                        title: 'Equipment',
                        leading: Icon(
                          Icons.kitchen,
                          size: 48.0,
                          color: Colors.white,
                        ),
                      ),
                    if (state.tokenInfo.permissions.contains('inventories'))
                      CompanionFullButton(
                        color: Colors.indigo,
                        onTap: () {
                          if (!characterState.itemsLoaded && !characterState.itemsLoading) {
                            BlocProvider.of<CharacterBloc>(context).add(LoadCharacterItemsEvent(characterState.characters));
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InventoryPage(_character),
                          ));
                        },
                        title: 'Inventory',
                        leading: Icon(
                          Icons.grid_on,
                          size: 48.0,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}