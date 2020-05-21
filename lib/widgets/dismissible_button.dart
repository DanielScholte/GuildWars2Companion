import 'package:flutter/material.dart';
import 'package:guildwars2_companion/widgets/button.dart';

class DismissibleButton extends StatelessWidget {
  final Key key;
  final Widget leading;
  final Widget trailing;
  final String title;
  final List<String> subtitles;
  final VoidCallback onTap;
  final VoidCallback onDismissed;
  final Color color;

  DismissibleButton({
    @required this.key,
    @required this.title,
    @required this.color,
    @required this.onDismissed,
    this.onTap,
    this.subtitles,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return CompanionButton(
      leading: leading,
      trailing: trailing,
      title: title,
      subtitles: subtitles,
      onTap: onTap,
      color: color,
      wrapper: (context, child) {
        return Dismissible(
          child: child,
          key: key,
          onDismissed: (_) => onDismissed(),
          background: dismissibleBackground(false),
          secondaryBackground: dismissibleBackground(true),
        );
      },
    );
  }

  Widget dismissibleBackground(bool end) {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: end ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!end)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          Text(
            'Delete Api Key',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0
            ),
          ),
          if (end)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}