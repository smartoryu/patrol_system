import 'package:nusalima_patrol_system/src/models.dart';

class ShiftReport {
  final String uid;
  final String shiftId;
  final Officer officer;
  final Location location;
  final String notes;
  final List<String> photos;
  final String lat;
  final String long;
  final String createdAt;
  final String updatedAt;

  ShiftReport({
    required this.uid,
    required this.shiftId,
    required this.officer,
    required this.location,
    required this.notes,
    required this.photos,
    required this.lat,
    required this.long,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShiftReport.fromJson(Map<String, dynamic> json) {
    return ShiftReport(
      uid: json['uid'],
      shiftId: json['shiftId'],
      officer: Officer.fromJson(json['officer']),
      location: Location.fromJson(json['location']),
      notes: json['notes'],
      photos: json['photos'].cast<String>(),
      lat: json['lat'],
      long: json['long'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
