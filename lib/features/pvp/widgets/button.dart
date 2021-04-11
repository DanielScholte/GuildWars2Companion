import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/pvp/bloc/pvp_bloc.dart';
import 'package:guildwars2_companion/features/pvp/pages/pvp.dart';

class PvpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      color: Color(0xFF678A9E),
      title: 'PvP',
      onTap: () {
        if (!(BlocProvider.of<PvpBloc>(context).state is LoadedPvpState)) {
          BlocProvider.of<PvpBloc>(context).add(LoadPvpEvent());
        }
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PvpPage()
        ));
      },
      leading: Image.asset(Assets.buttonHeaderPvp),
    );
  }
}