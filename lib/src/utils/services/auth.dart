import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusalima_patrol_system/src/models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on User
  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserModel?> get user =>
      _auth.authStateChanges().map(_userFromFirebase);

  // sign in anon
  Future<UserModel?> signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      rethrow;
    }
  }

  // register with email & password
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebase(user);
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
