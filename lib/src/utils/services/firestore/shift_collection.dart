import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../models.dart';

class ShiftCollection {
  final String uid;
  ShiftCollection({this.uid = ""});

  final CollectionReference collection =
      FirebaseFirestore.instance.collection("shifts");

  Stream<QuerySnapshot> get getAll {
    return collection.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> get getCurrent {
    return collection.doc(uid).snapshots();
  }

  Future create({
    required String name,
    required Officer officer,
    required Location location,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      var time = DateTime.now().toUtc().toIso8601String();
      var uid = const Uuid().v4();
      return await collection.doc(uid).set({
        "uid": uid,
        "officer": officer.toJson(),
        "location": location.toJson(),
        "startTime": startTime.toUtc().toIso8601String(),
        "endTime": endTime.toUtc().toIso8601String(),
        "createdAt": time,
        "updatedAt": time,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future createBulk(List<NewShift> shifts) async {
    try {
      var db = FirebaseFirestore.instance;
      var batch = db.batch();

      for (var shift in shifts) {
        var time = DateTime.now().toUtc().toIso8601String();
        var uid = const Uuid().v4();

        batch.set(db.collection("shifts").doc(uid), {
          "uid": uid,
          "officer": shift.officer.toJson(),
          "location": shift.location.toJson(),
          "startTime": shift.startTime.toUtc().toIso8601String(),
          "endTime": shift.endTime.toUtc().toIso8601String(),
          "createdAt": time,
          "updatedAt": time,
        });
      }

      return await batch.commit();
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
