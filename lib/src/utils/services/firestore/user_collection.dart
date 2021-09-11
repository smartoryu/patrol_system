import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';

class UserCollection {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get getAll {
    return collection.snapshots();
  }

  Future update({
    required String uid,
    required Map<String, dynamic> json,
  }) async {
    try {
      await collection.doc(uid).update(json);
    } catch (e) {
      rethrow;
    }
  }

  Future delete(String uid) async {
    try {
      await collection.doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future set({
    String? uid = "",
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
    required String position,
  }) async {
    try {
      if (uid == "") throw "Invalid UID";
      return await collection.doc(uid).set({
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
        'position': position,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Future<Map<String, dynamic>?> getSingle(String uid) async {
  Future<Officer?> getSingle(String uid) async {
    Map<String, dynamic>? data;
    var querySnapshot = await collection.where('uid', isEqualTo: uid).get();
    for (var snapshot in querySnapshot.docs) {
      data = jsonDecode(jsonEncode(snapshot.data()));
    }
    return data != null ? Officer.fromJson(data) : null;
  }
}
