import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanionTip extends StatelessWidget {
  final String tip;

  CompanionTip({
    @required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              FontAwesomeIcons.lightbulb,
              size: 20.0,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'Tip: ',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.w500
                ),
                children: [
                  TextSpan(
                    text: tip,
                    style: TextStyle(
                      fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              )
            )
          )
        ],
      ),
    );
  }
}