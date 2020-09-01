import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanionExpandableHeader extends StatefulWidget {

  final String header;
  final Widget trailing;
  final Widget child;
  final Color foreground;
  final Duration duration;

  const CompanionExpandableHeader({
    @required this.header,
    @required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.trailing,
    this.foreground = Colors.black
  });

  @override
  _CompanionExpandableHeaderState createState() => _CompanionExpandableHeaderState();
}

class _CompanionExpandableHeaderState extends State<CompanionExpandableHeader> with TickerProviderStateMixin {
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
                borderRadius: BorderRadius.circular(12.0),
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
                          widget.header,
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