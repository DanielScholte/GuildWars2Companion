import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  
  final String header;
  final String text;
  final Widget widget;

  InfoRow({
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
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            ),
          ),
          if (widget != null)
            widget
          else
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0
              ),
            )
        ],
      ),
    );
  }
}