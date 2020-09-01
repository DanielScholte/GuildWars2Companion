import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/widgets/simple_button.dart';

class CompanionError extends StatelessWidget {

  final String title;
  final VoidCallback onTryAgain;

  CompanionError({
    @required this.title,
    @required this.onTryAgain
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(FontAwesomeIcons.frown, size: 64.0,),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Something went wrong while loading $title",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            "Please check your internet connection",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        CompanionSimpleButton(
          text: 'Click here to try again',
          onPressed: () => onTryAgain(),
        )
      ],
    );
  }
}