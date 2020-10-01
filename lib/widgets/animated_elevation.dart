import 'package:flutter/material.dart';

class CompanionAnimatedElevation extends StatefulWidget {
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
  _CompanionAnimatedElevationState createState() => _CompanionAnimatedElevationState();
}

class _CompanionAnimatedElevationState extends State<CompanionAnimatedElevation> with SingleTickerProviderStateMixin {
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
    if (Theme.of(context).brightness == Brightness.dark) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _elevationAnimationTween,
      builder: (context, child) {
        return Material(
          elevation: _elevationAnimationTween.value,
          borderRadius: widget.borderRadius != null ? widget.borderRadius : BorderRadius.circular(13.0),
          child: child,
          shadowColor: widget.color,
        );
      },
      child: GestureDetector(
        onTapDown: !widget.disabled ? (_) => _elevationAnimationController.forward() : null,
        onTapUp: !widget.disabled ? (_) => _elevationAnimationController.reverse() : null,
        onTapCancel: !widget.disabled ? () => _elevationAnimationController.reverse() : null,
        child: widget.child
      ),
    );
  }
}