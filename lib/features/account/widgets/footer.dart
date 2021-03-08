import 'package:flutter/material.dart';

class TokenFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Container();
    }

    return Align(
      child: Image.asset(
        'assets/token_footer.png',
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.bottomLeft,
      ),
      alignment: Alignment.bottomLeft,
    );
  }
}