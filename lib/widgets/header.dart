import 'package:flutter/material.dart';

class CompanionHeader extends StatelessWidget {

  final Color color;
  final Widget child;
  final bool includeBack;

  CompanionHeader({
    @required this.child,
    this.color = Colors.red,
    this.includeBack = false
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
      ),
      width: double.infinity,
      child: includeBack ? Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: BackButton(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: child,
            )
          ),
        ],
      ) : SafeArea(
        minimum: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: child
      ),
    );
  }
}