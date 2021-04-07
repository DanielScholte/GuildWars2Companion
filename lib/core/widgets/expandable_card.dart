import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guildwars2_companion/core/widgets/animated_elevation.dart';

class CompanionExpandableCard extends StatelessWidget {
  final String title;
  final Widget trailing;
  final Widget child;
  final Color background;
  final Color foreground;
  final Duration duration;

  CompanionExpandableCard({
    @required this.title,
    @required this.child,
    @required this.background,
    this.foreground = Colors.black,
    this.duration = const Duration(milliseconds: 250),
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: CompanionAnimatedElevation(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: background,
          ),
          child: _Body(
            child: child,
            duration: duration,
            foreground: foreground,
            title: title,
            trailing: trailing,
          )
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final String title;
  final Widget trailing;
  final Widget child;
  final Color foreground;
  final Duration duration;

  _Body({
    @required this.title,
    @required this.foreground,
    @required this.duration,
    @required this.child,
    this.trailing
  });

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> with TickerProviderStateMixin {
  AnimationController _rotationController;
  bool _expanded = false;

  @override
  void initState() {
    _rotationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      child: Column(
        children: <Widget>[
          Container(
            height: 56.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: _expanded
                 ? BorderRadius.only(
                   topLeft: Radius.circular(12.0),
                   topRight: Radius.circular(12.0)
                 )
                 : BorderRadius.circular(12.0),
                onTap: () => setState(() {
                  _expanded = !_expanded;
                  _rotationController.animateTo(_expanded ? 1.0 : 0.0);
                }),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: widget.foreground
                          ),
                        ),
                      ),
                      if (widget.trailing != null)
                        widget.trailing,
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_rotationController),
                        child: Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 18.0,
                          color: widget.foreground
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_expanded)
            widget.child
        ],
      ),
      alignment: Alignment.topCenter,
      duration: widget.duration,
      vsync: this,
    );
  }
}