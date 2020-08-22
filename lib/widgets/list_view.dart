import 'package:flutter/material.dart';

class CompanionListView extends StatelessWidget {
  final List<Widget> children;

  CompanionListView({
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: MediaQuery
        .of(context)
        .padding
        .copyWith(
          top: 6.0,
          left: 0.0,
          right: 0.0,
        ),
      children: children,
    );
  }
}