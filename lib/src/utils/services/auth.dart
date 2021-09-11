import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/utils/_index.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on User
  Future<Officer?> _userFromFirebase(User? user) async {
    if (user != null) {
      var officer = await DatabaseService().users.getSingle(user.uid);
      return officer;
    } else {
      return null;
    }
    // return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Future<Officer?>> get user => _auth.authStateChanges().map((e) {
        var officer = _userFromFirebase(e);
        return officer;
      });

  // sign in anon
  Future<Officer?> signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      User? user = result.user;
      var officer = await _userFromFirebase(user);
      return officer;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future<Officer?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      var officer = await _userFromFirebase(user);
      return officer;
    } catch (e) {
      rethrow;
    }
  }

  // register with email & password
  Future<Officer?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String role,
    required String position,
  }) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      await DatabaseService().users.set(
            uid: user?.uid,
            email: email,
            password: password,
            fullName: fullName,
            phoneNumber: phoneNumber,
            role: role,
            position: position,
          );
      var officer = await _userFromFirebase(user);
      return officer;
    } catch (e) {
      rethrow;
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
