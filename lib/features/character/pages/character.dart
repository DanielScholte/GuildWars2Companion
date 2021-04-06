import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/utils/guild_wars_icons.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';
import 'package:guildwars2_companion/core/widgets/info_box.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/account/bloc/account_bloc.dart';
import 'package:guildwars2_companion/features/build/pages/build.dart';
import 'package:guildwars2_companion/features/character/bloc/character_bloc.dart';
import 'package:guildwars2_companion/features/character/models/character.dart';
import 'package:guildwars2_companion/features/character/pages/build_selection.dart';
import 'package:guildwars2_companion/features/character/pages/equipment.dart';
import 'package:guildwars2_companion/features/character/pages/equipment_selection.dart';
import 'package:guildwars2_companion/features/character/pages/inventory.dart';
import 'package:guildwars2_companion/features/character/widgets/crafting_card.dart';

class CharacterPage extends StatelessWidget {
  final Character _character;

  CharacterPage(this._character);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: _character.professionColor,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CompanionHeader(
              includeBack: true,
              color: _character.professionColor,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 28,
                        height: 28,
                        child: Hero(
                          child: ColorFiltered(
                            child: CompanionCachedImage(
                              imageUrl: _character.professionInfo.iconBig,
                              color: Colors.white,
                              iconSize: 20,
                              fit: BoxFit.contain,
                            ),
                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
                          ),
                          tag: _character.name,
                        ),
                      ),
                      Text(
                        _character.name,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white
                        )
                      )
                    ],
                  ),
                  if (_character.titleName != null && _character.titleName.isNotEmpty)
                    Text(
                      _character.titleName,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white
                      )
                    ),
                  Container(height: 8.0,),
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      runSpacing: 16.0,
                      children: <Widget>[
                        CompanionInfoBox(
                          header: 'Level',
                          text: _character.level.toString(),
                          loading: false,
                        ),
                        CompanionInfoBox(
                          header: 'Playtime',
                          text: GuildWarsUtil.calculatePlayTime(_character.age).toString() + 'h',
                          loading: false,
                        ),
                        CompanionInfoBox(
                          header: 'Deaths',
                          text: _character.deaths.toString(),
                          loading: false,
                        ),
                      ],
                    ),
                  ),
                  if (_character.crafting != null && _character.crafting.isNotEmpty)
                    CharacterCraftingCard(craftingList: _character.crafting)
                ],
              ),
            ),
            BlocBuilder<CharacterBloc, CharacterState>(
              builder: (context, state) {
                if (state is ErrorCharactersState) {
                  return Expanded(
                    child: Center(
                      child: CompanionError(
                        title: 'the character',
                        onTryAgain: () =>
                          BlocProvider.of<CharacterBloc>(context).add(LoadCharactersEvent()),
                      ),
                    ),
                  );
                }

                if (state is LoadedCharactersState) {
                  return _CharacterButtons(
                    character: _character,
                    detailsLoaded: state.detailsLoaded && !state.detailsLoading,
                  );
                }

                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _CharacterButtons extends StatelessWidget {
  final Character character;
  final bool detailsLoaded;
 
  _CharacterButtons({
    @required this.character,
    @required this.detailsLoaded
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return Expanded(
            child: RefreshIndicator(
              backgroundColor: Theme.of(context).accentColor,
              color: Theme.of(context).cardColor,
              onRefresh: () async {
                BlocProvider.of<CharacterBloc>(context).add(LoadCharactersEvent());
                await Future.delayed(Duration(milliseconds: 200), () {});
              },
              child: CompanionListView(
                children: <Widget>[
                  if (state.tokenInfo.permissions.contains('inventories')
                    && state.tokenInfo.permissions.contains('builds'))
                    CompanionButton(
                      color: Colors.teal,
                      onTap: () {
                        if (!detailsLoaded) {
                          BlocProvider.of<CharacterBloc>(context).add(LoadCharacterDetailsEvent());
                        }

                        if (character.equipmentTabs != null &&
                          character.equipmentTabs.where((e) => e.equipment != null && e.equipment.length > 0).length == 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EquipmentPage(
                              character,
                              character.equipmentTabs
                                .where((e) => e.equipment != null && e.equipment.length > 0)
                                .first
                                ..name = 'Equipment',
                              singular: true,
                            ),
                          ));

                          return;
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EquipmentSelectionPage(character),
                        ));
                      },
                      title: 'Equipment',
                      leading: Icon(
                        GuildWarsIcons.equipment,
                        size: 48.0,
                        color: Colors.white,
                      ),
                    ),
                  if (state.tokenInfo.permissions.contains('builds'))
                    CompanionButton(
                      color: Colors.purple,
                      onTap: () {
                        if (!detailsLoaded) {
                          BlocProvider.of<CharacterBloc>(context).add(LoadCharacterDetailsEvent());
                        }

                        if (character.buildTabs != null && character.buildTabs.length == 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BuildPage(character.buildTabs.first.build, singular: true,),
                          ));

                          return;
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CharacterBuildSelectionPage(character),
                        ));
                      },
                      title: 'Builds',
                      leading: Icon(
                        FontAwesomeIcons.hammer,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                  if (state.tokenInfo.permissions.contains('inventories'))
                    CompanionButton(
                      color: Colors.indigo,
                      onTap: () {
                        if (!detailsLoaded) {
                          BlocProvider.of<CharacterBloc>(context).add(LoadCharacterDetailsEvent());
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InventoryPage(character),
                        ));
                      },
                      title: 'Inventory',
                      leading: Icon(
                        GuildWarsIcons.inventory,
                        size: 48.0,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}