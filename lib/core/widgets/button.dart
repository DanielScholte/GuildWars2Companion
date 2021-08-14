import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/widgets/animated_elevation.dart';

class CompanionButton extends StatelessWidget {
  final bool loading;
  final Widget leading;
  final Widget trailing;
  final String title;
  final List<String> subtitles;
  final List<Widget> subtitleWidgets;
  final Function onTap;
  final double height;
  final Color color;
  final Color foregroundColor;
  final String hero;

  final Widget Function(BuildContext, Widget) wrapper;

  CompanionButton({
    @required this.title,
    @required this.color,
    this.onTap,
    this.height = 80.0,
    this.foregroundColor = Colors.white,
    this.subtitles,
    this.subtitleWidgets,
    this.leading,
    this.trailing,
    this.loading = false,
    this.hero,
    this.wrapper
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: CompanionAnimatedElevation(
        disabled: onTap == null,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? color : Color(0xFF323232),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: _Wrapper(
              wrapper: wrapper,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.black12,
                  highlightColor: Colors.black12,
                  onTap: onTap,
                  child: Row(
                    children: <Widget>[
                      _Leading(
                        child: leading,
                        height: height,
                        loading: loading,
                        hero: hero,
                      ),
                      _Title(
                        title: title,
                        subtitles: subtitles,
                        subtitleWidgets: subtitleWidgets,
                        foregroundColor: foregroundColor,
                      ),
                      if (trailing != null)
                        trailing,
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.chevronRight,
                          color: Theme.of(context).brightness == Brightness.light ? foregroundColor : Colors.white,
                          size: 18.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}

class _Wrapper extends StatelessWidget {
  final Widget Function(BuildContext, Widget) wrapper;
  final Widget child;

  _Wrapper({
    @required this.wrapper,
    @required this.child
  });

  @override
  Widget build(BuildContext context) {
    if (wrapper == null) {
      return child;
    }

    return wrapper(context, child);
  }
}

class _Title extends StatelessWidget {
  final String title;
  final List<String> subtitles;
  final List<Widget> subtitleWidgets;
  final Color foregroundColor;

  const _Title({
    @required this.title,
    this.subtitles,
    this.subtitleWidgets,
    this.foregroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light ? foregroundColor : Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitleWidgets != null)
            ...subtitleWidgets,
          if (subtitles != null)
            ...subtitles
              .map((subtitle) => Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light ? foregroundColor : Colors.white,
                  fontSize: 16.0,
                ),
              ))
              .toList()
        ],
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  final Widget child;
  final double height;
  final bool loading;
  final String hero;

  _Leading({
    @required this.child,
    @required this.height,
    @required this.loading,
    this.hero
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height == null ? 80.0 : height,
      height: height,
      color: Colors.black12,
      margin: EdgeInsets.only(right: 12.0),
      alignment: Alignment.center,
      child: this.loading
        ? CircularProgressIndicator(color: Colors.white)
        : Builder(
          builder: (context) {
            if (hero != null) {
              return Hero(
                tag: hero,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11.0),
                    bottomLeft: Radius.circular(11.0),
                  ),
                  child: child,
                ),
              );
            }

            return child;
          },
        ),
    );
  }
}