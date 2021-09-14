import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> upload({
    required String fileName,
    required File file,
    required String category,
  }) async {
    try {
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      Reference ref =
          storage.ref().child(category).child("${fileName}_$timestamp");
      UploadTask uploadTask = ref.putFile(file);

      var downloadURL = await (await uploadTask).ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteByUrl({required String url}) async {
    try {
      if (url == "") return;
      await storage.refFromURL(url).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future deleteBulkByUrl({required List<String> urls}) async {
    try {
      await Future.forEach(urls, (String url) async {
        await storage.refFromURL(url).delete();
      });
    } catch (e) {
      rethrow;
    }
  }
}
