import 'package:flutter/material.dart';

class CompanionListView extends StatelessWidget {
  final List<Widget> children;

  CompanionListView({
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets defaultPadding = MediaQuery
      .of(context)
      .padding;

    return ListView(
      padding: defaultPadding
        .copyWith(
          top: 6.0,
          left: 0.0,
          right: 0.0,
          bottom: defaultPadding.bottom > 6.0 ? defaultPadding.bottom : 6.0
        ),
      children: children,
    );
  }
}