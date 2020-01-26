import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class CompanionHeader extends StatelessWidget {

  final Color color;
  final Widget child;
  final bool includeBack;
  final String wikiName;

  CompanionHeader({
    @required this.child,
    this.color = Colors.red,
    this.includeBack = false,
    this.wikiName
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
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          if (includeBack)
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
          if (wikiName != null)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.wikipediaW,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    onPressed: () => Urls.launchUrl('https://wiki.guildwars2.com/index.php?search=${wikiName.replaceAll(' ', '+')}'),
                  )
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
      )
    );
  }
}