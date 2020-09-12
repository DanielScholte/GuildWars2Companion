import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/pages/character/equipment.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class EquipmentSelectionPage extends StatelessWidget {
  final Character _character;

  EquipmentSelectionPage(this._character);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.teal,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Equipment',
          color: Colors.teal,
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

              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<CharacterBloc>(context).add(RefreshCharacterDetailsEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: character.equipmentTabs
                    .where((e) => e.equipment != null && e.equipment.length > 0)
                    .map((e) => CompanionButton(
                      color: character.professionColor,
                      title: e.name != null && e.name.isNotEmpty ? e.name : 'Nameless equipment build',
                      height: 64,
                      subtitles: [
                        if (e.isActive)
                          'Active'
                      ],
                      leading: ColorFiltered(
                        child: CompanionCachedImage(
                          imageUrl: character.professionInfo.iconBig,
                          height: 48,
                          color: Colors.white,
                          iconSize: 28,
                          fit: BoxFit.cover,
                        ),
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EquipmentPage(character, e),
                      )),
                    ))
                    .toList()
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