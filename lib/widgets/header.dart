import 'package:flutter/material.dart';

class CompanionHeader extends StatelessWidget {

  final Color color;
  final Widget child;

  CompanionHeader({
    @required this.child,
    this.color = Colors.red
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8.0,
          ),
        ],
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0), bottomRight: Radius.circular(12.0))
      ),
      width: double.infinity,
      child: SafeArea(
        minimum: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: child
      ),
    );
  }
}