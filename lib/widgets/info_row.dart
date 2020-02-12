import 'package:flutter/material.dart';

class CompanionInfoRow extends StatelessWidget {
  
  final String header;
  final String text;
  final Widget widget;

  CompanionInfoRow({
    @required this.header,
    this.text,
    this.widget
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            header,
            style: Theme.of(context).textTheme.display3.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500
            ),
          ),
          if (widget != null)
            widget
          else
            Text(
              text,
              style: Theme.of(context).textTheme.display2.copyWith(
                color: Colors.black
              ),
            )
        ],
      ),
    );
  }
}