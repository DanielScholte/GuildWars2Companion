import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/guild_wars.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';
import 'package:guildwars2_companion/core/widgets/cached_image.dart';
import 'package:guildwars2_companion/features/error/widgets/error.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/core/widgets/list_view.dart';
import 'package:guildwars2_companion/features/character/bloc/character_bloc.dart';
import 'package:guildwars2_companion/features/character/models/character.dart';
import 'package:guildwars2_companion/features/character/pages/character.dart';

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
                  children: state.characters.map((c) => _CharacterButton(character: c)).toList(),
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

class _CharacterButton extends StatelessWidget {
  final Character character;

  _CharacterButton({
    @required this.character
  });

  @override
  Widget build(BuildContext context) {
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