import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/raid/bloc/raid_bloc.dart';
import 'package:guildwars2_companion/features/raid/pages/raids.dart';

class RaidButton extends StatelessWidget {
  final bool hasPermission;

  RaidButton({@required this.hasPermission});

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      color: Colors.blue,
      title: 'Raids',
      onTap: () {
        BlocProvider.of<RaidBloc>(context).add(LoadRaidsEvent(hasPermission));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RaidsPage()
        ));
      },
      leading: Image.asset(Assets.buttonHeaderRaids),
    );
  }
}