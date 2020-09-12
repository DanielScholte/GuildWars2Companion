import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guildwars2_companion/blocs/configuration/configuration_bloc.dart';
import 'package:guildwars2_companion/models/other/configuration.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class TimeConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Time notation',
        color: Colors.blue,
      ),
      body: BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (context, state) {
          final Configuration configuration = (state as LoadedConfiguration).configuration;
          
          return ListView(
            children: <Widget>[
              _buildTimeOption(context, configuration.timeNotation24Hours, true, '24 hours'),
              _buildTimeOption(context, configuration.timeNotation24Hours, false, '12 hours'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeOption(BuildContext context, bool currentNotation, bool notation, String title) {
    return RadioListTile(
      groupValue: currentNotation,
      value: notation,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      onChanged: (bool notation) => BlocProvider.of<ConfigurationBloc>(context).add(ChangeTimeNotationEvent(notation24Hours: notation)),
    );
  }
}