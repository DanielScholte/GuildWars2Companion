import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanionWarning extends StatelessWidget {
  final String warning;
  final bool android;
  final bool ios;

  CompanionWarning({
    @required this.warning,
    this.android = true,
    this.ios = true,
  });

  @override
  Widget build(BuildContext context) {
    if ((Platform.isIOS && ios == false) || (Platform.isAndroid && android == false)) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              FontAwesomeIcons.exclamationTriangle,
              size: 20.0,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'Warning: ',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.w500
                ),
                children: [
                  TextSpan(
                    text: warning,
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