import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class LocationCollection {
  final String uid;
  LocationCollection({this.uid = ""});

  final CollectionReference collection =
      FirebaseFirestore.instance.collection("locations");

  Stream<QuerySnapshot> get getAll {
    return collection.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> get getCurrent {
    return collection.doc(uid).snapshots();
  }

  Future create({
    required String name,
  }) async {
    try {
      var time = DateTime.now().toUtc().toIso8601String();
      var uid = const Uuid().v4();
      return await collection.doc(uid).set({
        "uid": uid,
        "name": name,
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
