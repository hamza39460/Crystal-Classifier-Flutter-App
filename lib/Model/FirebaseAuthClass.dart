import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthClass {
  FirebaseAuth _firebaseAuth;

  FirebaseAuthClass(Function onAuthStateChangeCallBack) {
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.authStateChanges().listen(onAuthStateChangeCallBack);
  }

  getAuthInstance() => _firebaseAuth;

  Future<String> loginWithEmailandPwd(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;

    return user.uid;
  }

  Future<String> resetPWD(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> signUpWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  Future<User> getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = await _firebaseAuth.currentUser;
    try {
      return user.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    await user.reload();
    return user.emailVerified;
  }

  Future<bool> loginState() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      User user = _firebaseAuth.currentUser;
      await user.updateEmail(newEmail);
    } catch (e) {
      throw e;
    }
  }

  Future<void> reauthenticate(String email, String pwd) async {
    try {
      User user = _firebaseAuth.currentUser;
      await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: pwd));
    } catch (e) {
      throw e;
    }
  }
}
