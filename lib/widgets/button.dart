import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanionButton extends StatefulWidget {
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
  _CompanionButtonState createState() => _CompanionButtonState();
}

class _CompanionButtonState extends State<CompanionButton> with SingleTickerProviderStateMixin {
  AnimationController _elevationAnimationController;
  Animation<double> _elevationAnimationTween;

  @override
  void initState() {
    super.initState();

    _elevationAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimationTween = Tween(begin: 2.0, end: 8.0).animate(_elevationAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: AnimatedBuilder(
        animation: _elevationAnimationTween,
        builder: (context, child) {
          return Material(
            elevation: Theme.of(context).brightness == Brightness.light ? _elevationAnimationTween.value : 0,
            borderRadius: BorderRadius.circular(13.0),
            child: child,
            shadowColor: Colors.black87,
          );
        },
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? widget.color : Color(0xFF323232),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: widget.wrapper != null ? widget.wrapper(context, _buildBody(context)) : _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return widget.onTap != null ? Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.black12,
        highlightColor: Colors.black12,
        onTap: () => widget.onTap(),
        onFocusChange: (value) => !value ? _elevationAnimationController.reverse() : _elevationAnimationController.animateTo(.5),
        onHover: (value) => !value ? _elevationAnimationController.reverse() : _elevationAnimationController.animateTo(.5),
        onHighlightChanged: (value) => !value ? _elevationAnimationController.reverse() : _elevationAnimationController.forward(),
        child: Row(
          children: <Widget>[
            _buildLeadingContainer(context),
            _buildTitle(context),
            if (widget.trailing != null)
              widget.trailing,
            _buildArrow(context)
          ],
        ),
      ),
    ) : Row(
      children: <Widget>[
        _buildLeadingContainer(context),
        _buildTitle(context),
        if (widget.trailing != null)
          widget.trailing,
      ],
    );
  }

  Widget _buildLeadingContainer(BuildContext context) {
    return Container(
      width: widget.height == null ? 80.0 : widget.height,
      height: widget.height,
      color: Colors.black12,
      margin: EdgeInsets.only(right: 12.0),
      alignment: Alignment.center,
      child: this.widget.loading ?
        Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: CircularProgressIndicator(),
        ) : _buildLeading(context),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (widget.hero != null) {
      return Hero(
        tag: widget.hero,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(11.0),
            bottomLeft: Radius.circular(11.0),
          ),
          child: widget.leading,
        ),
      );
    }

    return widget.leading;
  }

  Widget _buildTitle(BuildContext context) {
    List<Widget> titles = [
      Text(
        this.widget.title,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ? widget.foregroundColor : Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w500
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ];

    if (this.widget.subtitleWidgets != null) {
      titles.addAll(this.widget.subtitleWidgets);
    }

    if (this.widget.subtitles != null) {
      titles.addAll(
        this.widget.subtitles.map(
          (s) => Text(
            s,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light ? widget.foregroundColor : Colors.white,
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
        color: Theme.of(context).brightness == Brightness.light ? widget.foregroundColor : Colors.white,
        size: 18.0,
      ),
    );
  }
}