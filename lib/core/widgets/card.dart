import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/widgets/content_elevation.dart';

class CompanionCard extends StatelessWidget {

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color backgroundColor;

  CompanionCard({
    @required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = 12.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: CompanionContentElevation(
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor != null ? backgroundColor : Theme.of(context).cardColor,
          ),
          child: child
        ),
      ),
    );
  }
}