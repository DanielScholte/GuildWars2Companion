import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompanionButton extends StatelessWidget {
  final bool fullWidth;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final EdgeInsets padding;

  CompanionButton({
    this.fullWidth = true,
    this.color = const Color(0xFFAA0404),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.only(left: 8.0, right: 8.0),
    @required this.text,
    this.icon,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: fullWidth ? double.infinity : null,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          color: color,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    icon,
                    color: Colors.white
                  ),
                ),
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () => onTap(),
        ),
      ),
    );
  }
}