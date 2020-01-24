import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/pages/character/character.dart';
import 'package:guildwars2_companion/utils/guild_wars.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:guildwars2_companion/widgets/error.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class CharactersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.blue),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Characters',
          color: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4.0,
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
                color: Colors.white,
                onRefresh: () async {
                  BlocProvider.of<CharacterBloc>(context).add(LoadCharactersEvent());
                  await Future.delayed(Duration(milliseconds: 200), () {});
                },
                child: ListView(
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
    return CompanionFullButton(
      color: character.professionColor,
      title: character.name,
      leading: Hero(
        child: ColorFiltered(
          child: CachedNetworkImage(
            imageUrl: character.professionInfo.iconBig,
            placeholder: (context, url) => Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Center(child: Icon(
              FontAwesomeIcons.dizzy,
              size: 28.0,
              color: Colors.white,
            )),
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
