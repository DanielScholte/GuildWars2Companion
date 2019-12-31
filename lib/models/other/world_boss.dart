import 'package:flutter/foundation.dart';

class WorldBoss {
  String name;
  String id;
  String location;
  DateTime dateTime;
  DateTime refreshTime;
  List<String> times;

  WorldBoss({
    @required this.name,
    @required this.location,
    this.id,
    this.dateTime,
    this.refreshTime,
    this.times
  });
}