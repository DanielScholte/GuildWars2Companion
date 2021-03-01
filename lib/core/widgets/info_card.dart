import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';

class CompanionInfoCard extends StatelessWidget {
  final String title;
  final String text;
  final Widget child;

  CompanionInfoCard({
    @required this.title,
    this.text,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return CompanionCard(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          if (text != null)
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          if (child != null)
            child
        ],
      ),
    );
  }
}