import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/core/widgets/accent.dart';
import 'package:guildwars2_companion/features/configuration/bloc/configuration_bloc.dart';
import 'package:guildwars2_companion/core/widgets/appbar.dart';

class TimeConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CompanionAccent(
      lightColor: Colors.blue,
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Time notation',
          color: Colors.blue,
        ),
        body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
          builder: (context, state) {
            List<_TimeNotation> notations = [
              _TimeNotation('24 hours', true),
              _TimeNotation('12 hours', false)
            ];

            return ListView(
              children: notations
                .map((notation) => RadioListTile(
                  groupValue: state.configuration.timeNotation24Hours,
                  value: notation.notation24Hour,
                  title: Text(
                    notation.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onChanged: (bool notation) => BlocProvider.of<ConfigurationBloc>(context).add(ChangeTimeNotationEvent(notation24Hours: notation)),
                ))
                .toList()
            );
          },
        ),
      ),
    );
  }
}

class _TimeNotation {
  final String name;
  final bool notation24Hour;

  _TimeNotation(this.name, this.notation24Hour);
}