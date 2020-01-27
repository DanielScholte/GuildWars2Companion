import 'package:flutter/widgets.dart';

class MetaEventSequence {
  String id;
  String name;
  String region;
  List<MetaEventSegment> segments;

  MetaEventSequence({
    @required this.id,
    @required this.name,
    @required this.region,
    @required this.segments,
  });
}

class MetaEventSegment {
  String name;
  Duration duration;
  List<DateTime> times;
  DateTime time;

  MetaEventSegment({
    this.name,
    @required this.duration,
    this.times,
    this.time,
  });
}