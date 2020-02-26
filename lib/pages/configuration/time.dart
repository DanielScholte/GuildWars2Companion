import 'package:flutter/material.dart';
import 'package:guildwars2_companion/providers/configuration.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';
import 'package:provider/provider.dart';

class TimeConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanionAppBar(
        title: 'Time notation',
        color: Colors.blue,
        elevation: 4.0,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ConfigurationProvider>(
        builder: (context, state, child) {
          return ListView(
            children: [
              _buildTimeOption(context, state.timeNotation24Hours, true, '24 hours'),
              _buildTimeOption(context, state.timeNotation24Hours, false, '12 hours'),
            ]
          );
        }
      ),
    );
  }

  Widget _buildTimeOption(BuildContext context, bool currentNotation, bool notation, String title) {
    return RadioListTile(
      groupValue: currentNotation,
      value: notation,
      title: Text(
        title,
        style: Theme.of(context).textTheme.display3,
      ),
      onChanged: (bool notation) =>
        Provider.of<ConfigurationProvider>(context, listen: false).changeTimeNotation(notation),
    );
  }
}