import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/pages/general/build/build.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class CharacterBuildSelectionPage extends StatelessWidget {
  final Character _character;

  CharacterBuildSelectionPage(this._character);

  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.purple,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Builds',
          color: Colors.purple,
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
                  children: character.buildTabs
                    .map((b) => CompanionButton(
                      color: character.professionColor,
                      title: b.build.name != null && b.build.name.isNotEmpty ? b.build.name : 'Nameless build',
                      height: 64,
                      subtitles: [
                        if (b.isActive)
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
                        builder: (context) => BuildPage(b.build)
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