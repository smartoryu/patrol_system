import 'package:nusalima_patrol_system/src/models/_index.dart';

class NewShift {
  final String uid;
  final Officer officer;
  final Location location;
  final DateTime startTime;
  final DateTime endTime;

  NewShift({
    required this.uid,
    required this.officer,
    required this.location,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "officer": officer.toJson(),
      "location": location.toJson(),
      "startTime": startTime,
      "endTime": endTime
    };
  }
}
