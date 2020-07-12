import 'package:flutter/material.dart';

class CompanionInfoColumn extends StatelessWidget {
  
  final String header;
  final String text;
  final Widget leadingWidget;

  CompanionInfoColumn({
    @required this.header,
    this.text,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (leadingWidget != null)
                leadingWidget,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  header,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}