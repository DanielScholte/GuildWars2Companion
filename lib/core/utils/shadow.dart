import 'package:flutter/material.dart';

class ShadowUtil {
  static BoxShadow getMaterialShadow() => BoxShadow(
    color: Colors.black26,
    spreadRadius: -0.25,
    offset: Offset(0, 1.75),
    blurRadius: 2.0,
  );
}