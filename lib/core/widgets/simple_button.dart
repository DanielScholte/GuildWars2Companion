import 'package:flutter/material.dart';

class CompanionSimpleButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  CompanionSimpleButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).cardColor
          )
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}