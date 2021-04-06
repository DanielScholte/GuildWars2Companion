import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/world_boss/bloc/world_boss_bloc.dart';
import 'package:guildwars2_companion/features/world_boss/pages/world_bosses.dart';

class WorldBossButton extends StatelessWidget {
  final bool hasPermission;

  WorldBossButton({@required this.hasPermission});

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      color: Colors.deepPurple,
      title: 'World bosses',
      onTap: () {
        BlocProvider.of<WorldBossBloc>(context).add(LoadWorldbossesEvent(true, hasPermission));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WorldBossesPage()
        ));
      },
      leading: Image.asset(Assets.buttonHeaderWorldBosses),
    );
  }
}