import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/utils/_index.dart';

class UserCollection {
  final String uid;
  UserCollection({this.uid = ''});

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get getAll {
    return collection.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> get getCurrent {
    var snap = collection.doc(uid).snapshots();
    return snap;
  }

  Future update({
    required String uid,
    required Map<String, dynamic> json,
  }) async {
    try {
      json["updatedAt"] = DateTime.now().toIso8601String();
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
    String officerId = "",
    required String position,
  }) async {
    try {
      if (uid == "") throw "Invalid UID";
      var time = DateTime.now().toIso8601String();
      return await collection.doc(uid).set({
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'officerId': officerId,
        'phoneNumber': phoneNumber,
        'position': position,
        'photo': "",
        'role': role,
        'createdAt': time,
        'updatedAt': time,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Officer?> getSingle(String uid) async {
    Map<String, dynamic>? data;
    var querySnapshot = await collection.where('uid', isEqualTo: uid).get();
    for (var snapshot in querySnapshot.docs) {
      data = jsonDecode(jsonEncode(snapshot.data()));
    }
    return data != null ? Officer.fromJson(data) : null;
  }

  Future uploadPhoto(String uid, [String imgUrl = ""]) async {
    String fileName = "profile";
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    // var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      await StorageService().deleteByUrl(url: imgUrl);

      var downloadURL = await StorageService().upload(
        fileName: fileName,
        file: file,
      );

      debugPrint(downloadURL);

      await collection.doc(uid).update({
        "photo": downloadURL,
      });
    }
  }
}
