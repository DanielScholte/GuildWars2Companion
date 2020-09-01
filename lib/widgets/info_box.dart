import 'package:flutter/material.dart';

class CompanionInfoBox extends StatelessWidget {
  final String header;
  final String text;
  final Widget widget;
  final Color borderColor;
  final Color textColor;
  final double width;
  final double height;
  final bool loading;

  CompanionInfoBox({
    @required this.header,
    this.text = '?',
    this.loading = true,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.width = 100.0,
    this.height = 80.0,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              color: textColor,
              fontSize: 12.0
            ),
            textAlign: TextAlign.center,
          ),
          if (loading)
            Theme(
              data: Theme.of(context).copyWith(accentColor: borderColor),
              child: Container(
                width: 22.0,
                height: 22.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                )
              ),
            ),
          if (!loading && widget == null)
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w600
              ),
            ),
          if (!loading && widget != null)
            widget
        ],
      ),
    );
  }
}