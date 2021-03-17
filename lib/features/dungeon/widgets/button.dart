import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/dungeon/bloc/dungeon_bloc.dart';
import 'package:guildwars2_companion/features/dungeon/pages/dungeons.dart';

class DungeonButton extends StatelessWidget {
  final bool hasPermission;

  DungeonButton({@required this.hasPermission});

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      color: Colors.deepOrange,
      title: 'Dungeons',
      onTap: () {
        BlocProvider.of<DungeonBloc>(context).add(LoadDungeonsEvent(hasPermission));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DungeonsPage()
        ));
      },
      leading: Image.asset(Assets.buttonHeaderDungeons),
    );
  }
}