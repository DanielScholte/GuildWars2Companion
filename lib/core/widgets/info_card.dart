import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/card.dart';

class CompanionInfoCard extends StatelessWidget {
  final String title;
  final String text;
  final Widget child;
  final EdgeInsets childPadding;

  CompanionInfoCard({
    @required this.title,
    this.childPadding = const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
    this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          if (text != null)
            Padding(
              padding: childPadding,
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          if (child != null)
            Padding(
              padding: childPadding,
              child: child,
            )
        ],
      ),
    );
  }
}