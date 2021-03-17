import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/widgets/button.dart';
import 'package:guildwars2_companion/features/meta_event/bloc/event_bloc.dart';
import 'package:guildwars2_companion/features/meta_event/pages/meta_events.dart';

class MetaEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      color: Colors.green,
      title: 'Meta Events',
      onTap: () {
        BlocProvider.of<MetaEventBloc>(context).add(LoadMetaEventsEvent());
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MetaEventsPage()
        ));
      },
      leading: Image.asset(Assets.buttonHeaderEvents),
    );
  }
}