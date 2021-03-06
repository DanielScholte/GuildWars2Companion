import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/widgets/animated_elevation.dart';

class CompanionButton extends StatelessWidget {
  final bool loading;
  final Widget leading;
  final Widget trailing;
  final String title;
  final List<String> subtitles;
  final List<Widget> subtitleWidgets;
  final VoidCallback onTap;
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
            child: wrapper != null ? wrapper(context, _buildBody(context)) : _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return onTap != null ? Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.black12,
        highlightColor: Colors.black12,
        onTap: () => onTap(),
        child: Row(
          children: <Widget>[
            _buildLeadingContainer(context),
            _buildTitle(context),
            if (trailing != null)
              trailing,
            _buildArrow(context)
          ],
        ),
      ),
    ) : Row(
      children: <Widget>[
        _buildLeadingContainer(context),
        _buildTitle(context),
        if (trailing != null)
          trailing,
      ],
    );
  }

  Widget _buildLeadingContainer(BuildContext context) {
    return Container(
      width: height == null ? 80.0 : height,
      height: height,
      color: Colors.black12,
      margin: EdgeInsets.only(right: 12.0),
      alignment: Alignment.center,
      child: this.loading ?
        Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: CircularProgressIndicator(),
        ) : _buildLeading(context),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (hero != null) {
      return Hero(
        tag: hero,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(11.0),
            bottomLeft: Radius.circular(11.0),
          ),
          child: leading,
        ),
      );
    }

    return leading;
  }

  Widget _buildTitle(BuildContext context) {
    List<Widget> titles = [
      Text(
        this.title,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ? foregroundColor : Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w500
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ];

    if (this.subtitleWidgets != null) {
      titles.addAll(this.subtitleWidgets);
    }

    if (this.subtitles != null) {
      titles.addAll(
        this.subtitles.map(
          (s) => Text(
            s,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light ? foregroundColor : Colors.white,
              fontSize: 16.0,
            ),
          )
        ).toList()
      );
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: titles,
      ),
    );
  }

  Widget _buildArrow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        FontAwesomeIcons.chevronRight,
        color: Theme.of(context).brightness == Brightness.light ? foregroundColor : Colors.white,
        size: 18.0,
      ),
    );
  }
}