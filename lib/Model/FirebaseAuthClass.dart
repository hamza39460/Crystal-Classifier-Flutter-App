import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthClass {
  FirebaseAuth _firebaseAuth;
  
  FirebaseAuthClass(Function onAuthStateChangeCallBack) {
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.onAuthStateChanged.listen(onAuthStateChangeCallBack);
  }

  getAuthInstance() => _firebaseAuth;

  Future<String> loginWithEmailandPwd(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    return user.uid;
  }

  Future<String> resetPWD(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> signUpWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }
  
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    try {
      return user.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await user.reload();
    return user.isEmailVerified;
  }

  Future<bool> loginState() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

}