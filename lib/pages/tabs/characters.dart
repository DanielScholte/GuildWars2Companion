import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/pages/character/character.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/accent.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/cached_image.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/button.dart';
import 'package:guildwars2_companion/widgets/list_view.dart';

class CharactersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Characters',
          color: Colors.blue,
        ),
        body: BlocBuilder<CharacterBloc, CharacterState>(
          builder: (context, state) {
            if (state is ErrorCharactersState) {
              return Center(
                child: CompanionError(
                  title: 'the characters',
                  onTryAgain: () =>
                    BlocProvider.of<CharacterBloc>(context).add(LoadCharactersEvent()),
                ),
              );
            }

            if (state is LoadedCharactersState) {
              return RefreshIndicator(
                backgroundColor: Theme.of(context).accentColor,
                color: Theme.of(context).cardColor,
                onRefresh: () async {
                  BlocProvider.of<CharacterBloc>(context).add(LoadCharactersEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: CompanionListView(
                  children: state.characters.map((c) => _buildCharacterRow(context, c)).toList(),
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

  Widget _buildCharacterRow(BuildContext context, Character character) {
    return CompanionButton(
      color: character.professionColor,
      title: character.name,
      leading: Hero(
        child: ColorFiltered(
          child: CompanionCachedImage(
            imageUrl: character.professionInfo.iconBig,
            color: Colors.white,
            iconSize: 28,
            fit: BoxFit.cover,
          ),
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
        ),
        tag: character.name,
      ),
      subtitles: [
        'Level ${character.level} ${character.race} ${character.professionInfo.name}',
        '${GuildWarsUtil.calculatePlayTime(character.age)} hours of playtime'
      ],
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CharacterPage(character)
      )),
    );
  }
}
