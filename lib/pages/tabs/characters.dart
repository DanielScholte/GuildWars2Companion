import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/pages/character/character.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/widgets/full_button.dart';

class CharactersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is LoadedCharactersState) {
            return ListView(
              children: state.characters.map((c) => _buildCharacterRow(context, c)).toList(),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildCharacterRow(BuildContext context, Character character) {
    return CompanionFullButton(
      color: character.professionColor,
      title: character.name,
      leading: ColorFiltered(
        child: CachedNetworkImage(
          imageUrl: character.professionInfo.iconBig,
          placeholder: (context, url) => Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
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