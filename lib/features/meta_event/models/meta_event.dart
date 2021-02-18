import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';

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
}

