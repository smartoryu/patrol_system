import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/utils/_index.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on User
  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // change email
  Future changeEmail(String _email, String _password) async {
    var user = _auth.currentUser;
    if (user == null) return;

    var email = user.email ?? "";

    try {
      await signInWithEmailAndPassword(email, _password);
      await user.updateEmail(_email);
    } catch (e) {
      rethrow;
    }
  }

  // change password
  Future changePassword(String _oldPassword, String _newPassword) async {
    var user = _auth.currentUser;
    if (user == null) return;

    var email = user.email ?? "";

    try {
      await signInWithEmailAndPassword(email, _oldPassword);
      await user.updatePassword(_newPassword);
    } catch (e) {
      rethrow;
    }
  }

  // auth change user stream
  Stream<UserModel?> get user =>
      _auth.authStateChanges().map(_userFromFirebase);

  // sign in anon
  Future signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      User? user = result.user;
      var officer = _userFromFirebase(user);
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
      var officer = await DatabaseService().users.getSingle(user?.uid ?? "");
      return officer;
    } catch (e) {
      rethrow;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String role,
    required String officerId,
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
            officerId: officerId,
            phoneNumber: phoneNumber,
            position: position,
            role: role,
          );
      // var officer = await DatabaseService().users.getSingle(user?.uid ?? "");
      // return officer;
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
