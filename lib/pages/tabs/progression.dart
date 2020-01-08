import 'package:flutter/material.dart';
import 'package:guildwars2_companion/widgets/appbar.dart';

class ProgressionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.indigo),
      child: Scaffold(
        appBar: CompanionAppBar(
          title: 'Progression',
          color: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
      ),
    );
  }
}