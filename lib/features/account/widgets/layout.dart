import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guildwars2_companion/core/widgets/header.dart';

class TokenLayout extends StatelessWidget {
  final Widget child;

  TokenLayout({
    @required this.child
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light
      ),
      child: Stack(
        children: <Widget>[
          _Footer(),
          Column(
            children: <Widget>[
              _Header(),
              Expanded(child: child)
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return CompanionHeader(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/token_header_logo.png',
              height: 64.0,
            ),
            Container(width: 8.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'GW2 Companion',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  'Api Keys',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/token_header.png',
          height: 170.0,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
        SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Image.asset(
                'assets/token_header_logo.png',
                height: 72.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
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