import 'package:flutter/material.dart';

class CompanionCard extends StatelessWidget {

  final Widget child;

  CompanionCard({
    @required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.white,
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