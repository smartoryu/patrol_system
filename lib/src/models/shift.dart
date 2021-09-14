import 'package:nusalima_patrol_system/src/models/_index.dart';

class Shift {
  final String uid;
  final Officer officer;
  final Location location;
  final String startTime;
  final String endTime;
  final String createdAt;
  final String updatedAt;
  final bool isDone;

  Shift({
    required this.uid,
    required this.officer,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    required this.isDone,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      uid: json['uid'],
      officer: Officer.fromJson(json['officer']),
      location: Location.fromJson(json['location']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isDone: json['isDone'] ?? false,
    );
  }
}
