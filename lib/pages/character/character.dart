import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/character/bloc.dart';
import 'package:guildwars2_companion/models/character/character.dart';
import 'package:guildwars2_companion/utils/gw.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
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
                    minimum: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        )
                      ],
                    ),
                  ),
                ),
                MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: Expanded(
                    child: ListView(
                      children: <Widget>[
                      ],
                    ),
                  ),
                )
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

}