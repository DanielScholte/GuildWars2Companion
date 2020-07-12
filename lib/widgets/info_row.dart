import 'package:flutter/material.dart';

class CompanionInfoRow extends StatelessWidget {
  
  final String header;
  final String text;
  final Widget leadingWidget;
  final Widget widget;

  CompanionInfoRow({
    @required this.header,
    this.text,
    this.leadingWidget,
    this.widget
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (leadingWidget != null)
                leadingWidget,
              Column(
                children: <Widget>[
                  Text(
                    header,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (widget != null)
            widget
          else
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.end,
              ),
            )
        ],
      ),
    );
  }
}