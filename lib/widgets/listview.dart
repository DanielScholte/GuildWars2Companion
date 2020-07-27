import 'package:flutter/material.dart';

class CompanionListView extends StatelessWidget {
  final List<Widget> children;

  CompanionListView({
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      children: children,
    );
  }
}