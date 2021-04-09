import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/core/models/event_segment.dart';

class MetaEventSequence {
  String id;
  String name;
  String region;
  Duration offset;
  List<MetaEventSegment> segments;

  MetaEventSequence({
    this.id,
    this.name,
    this.region,
    @required this.segments,
    this.offset = Duration.zero,
  });

  MetaEventSequence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    offset = Duration(minutes: json['offsetInMinutes']);
    if (json['segments'] != null) {
      segments = (json['segments'] as List)
        .map((j) => MetaEventSegment.fromJson(j))
        .toList();
    }
  }
}

