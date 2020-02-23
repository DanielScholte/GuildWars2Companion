import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? color : Color(0xFF323232),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
            ),
        ],
      ),
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: onTap != null ? Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black12,
            highlightColor: Colors.black12,
            onTap: () => onTap(),
            child: Row(
              children: <Widget>[
                _buildLeadingContainer(context),
                _buildTitle(),
                if (trailing != null)
                  trailing,
                _buildArrow()
              ],
            ),
          ),
        ) : Row(
          children: <Widget>[
            _buildLeadingContainer(context),
            _buildTitle(),
            if (trailing != null)
              trailing,
          ],
        ),
      ),
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

  Widget _buildTitle() {
    List<Widget> titles = [
      Text(
        this.title,
        style: TextStyle(
          color: foregroundColor,
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
              color: foregroundColor,
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

  Widget _buildArrow() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        FontAwesomeIcons.chevronRight,
        color: foregroundColor,
        size: 18.0,
      ),
    );
  }
}