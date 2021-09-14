import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:uuid/uuid.dart';

class ShiftReportCollection {
  final String uid;
  ShiftReportCollection({this.uid = ""});

  final CollectionReference collection =
      FirebaseFirestore.instance.collection("shift_report");

  Stream<QuerySnapshot> get getAll {
    return collection.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> get getCurrent {
    return collection.doc(uid).snapshots();
  }

  Future create({
    required String shiftId,
    required Officer officer,
    required Location location,
    required String notes,
    required List<String> photos,
    required String lat,
    required String long,
  }) async {
    try {
      var time = DateTime.now().toUtc().toIso8601String();
      var uid = const Uuid().v4();

      return await collection.doc(uid).set({
        "uid": uid,
        "shiftId": shiftId,
        "officer": officer.toJson(),
        "location": location.toJson(),
        "notes": notes,
        "photos": photos,
        "lat": lat,
        "long": long,
        "createdAt": time,
        "updatedAt": time,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future update({required Map<String, dynamic> json}) async {
    try {
      json["updatedAt"] = DateTime.now().toUtc().toIso8601String();
      await collection.doc(uid).update(json);
    } catch (e) {
      rethrow;
    }
  }

  Future delete() async {
    try {
      await collection.doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}
