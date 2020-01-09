import 'package:flutter/material.dart';

class CompanionCard extends StatelessWidget {

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color backgroundColor;

  CompanionCard({
    @required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = 12.0,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8.0),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
          ),
        ]
      ),
      child: child
    );
  }
}