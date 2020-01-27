import 'package:flutter/widgets.dart';

class MetaEventSequence {
  String id;
  String name;
  String region;
  Duration offset;
  List<MetaEventSegment> segments;

  MetaEventSequence({
    @required this.id,
    @required this.name,
    @required this.region,
    @required this.segments,
    this.offset = Duration.zero,
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