import 'package:flutter/material.dart';

class CompanionAnimatedElevation extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  CompanionAnimatedElevation({
    @required this.child,
    this.disabled = false,
    this.color = Colors.black87,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return child;
    }

    return _AnimatedElevation(
      child: child,
      borderRadius: borderRadius,
      color: color,
      disabled: disabled,
    );
  }
}

class _AnimatedElevation extends StatefulWidget {
  final Widget child;
  final bool disabled;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  _AnimatedElevation({
    @required this.child,
    this.disabled = false,
    this.color = Colors.black87,
    this.borderRadius,
  });
  
  @override
  _AnimatedElevationState createState() => _AnimatedElevationState();
}

class _AnimatedElevationState extends State<_AnimatedElevation> with SingleTickerProviderStateMixin {
  static double _defaultElevation = 2.0;
  static double _tappedElevation = 8.0;
  double _elevation = _defaultElevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: _elevation,
      borderRadius: widget.borderRadius != null ? widget.borderRadius : BorderRadius.circular(13.0),
      child: GestureDetector(
        child: widget.child,
        onTapDown: (_) => _setElevation(_tappedElevation),
        onTapUp: (_) => _setElevation(_defaultElevation),
        onTapCancel: () => _setElevation(_defaultElevation),
      ),
      shadowColor: widget.color,
    );
  }

  void _setElevation(double elevation) {
    if (widget.disabled || _elevation == elevation) {
      return;
    }

    setState(() {
      _elevation = elevation;
    });
  }
}