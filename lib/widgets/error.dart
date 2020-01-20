import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            "Please check your internet connection",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
        Container(
          width: 400,
          padding: EdgeInsets.all(8.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0),
            ),
            color: Theme.of(context).accentColor,
            child: Text(
              'Click here to try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => onTryAgain(),
          ),
        ),
      ],
    );
  }
}