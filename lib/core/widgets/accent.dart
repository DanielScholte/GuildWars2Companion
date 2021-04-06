import 'package:flutter/material.dart';

class CompanionAccent extends StatelessWidget {

  final Color lightColor;
  final Widget child;

  CompanionAccent({
    @required this.lightColor,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return child;
    }

    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: lightColor,
      ),
      child: child,
    );
  }
}