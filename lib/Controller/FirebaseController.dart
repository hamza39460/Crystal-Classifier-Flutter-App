import 'dart:io';

import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Model/FirebaseAuthClass.dart';
import 'package:crystal_classifier/Model/FirebaseDatabaseClass.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crystal_classifier/View/Widgets/CustomSnackbar.dart';

class FirebaseController {
  static final FirebaseController _selfInstance = FirebaseController._internal();
  
  static FirebaseAuthClass _firebaseAuth;
  static FirebaseDatabaseClass _firebaseDatabase=FirebaseDatabaseClass();

  FirebaseController._internal(){
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:43:26 
     * @Desc: Internal Constructor for UserController Class 
     */
    _firebaseAuth = FirebaseAuthClass(
      _authStateChanged
    );

  }

  factory FirebaseController.init(){
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:45:35 
     * @Desc: Returns Instance of UserController class 
     */
    return _selfInstance;
  }

 Future<bool> loginWithEmailAndPwd(String email, String password) async {
    try {
      await _firebaseAuth.loginWithEmailandPwd(email, password);
      return true;
    } catch (e) {
      String _message = _getError(e);
      CustomSnackbar().showError(_message);
      print('sign in error $e');
      return false;
     }
  } 

  Future <bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signUpWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      String _message = _getError(e);
      CustomSnackbar().showError(_message);
      print('signup error $e');
      return false;
      //notifyListeners();
      //_showError();
    }
  }

  Future <bool> addUserToDb(UserDescriptor user,File image)async {
      try{
      await _firebaseDatabase.addUserToDB(user, image);
      return true;
      }
      catch(e){
        print('Adding user to DB Error $e');
        return false;
      }
      
  }

  Future<bool> getUserFromDB(UserDescriptor user,String email)async{
    try{
      await _firebaseDatabase.getUserFromDB(email, user);
      print("User01: ${user.getUserDetails()}");
      return true;
    }
    catch(e){
      print('Getting user from DB error $e ');
      return false;
    }
  }
  Future<void> _authStateChanged(FirebaseUser user) async {
    if (user == null) {
      UserController.init().setUserAuthState(UserAuthState.Unauthenticated);

    } else{
      UserController.init().setUserAuthState(UserAuthState.Authenticated);
       //   print('logged in');
   //   _userAuthState=UserAuthState.Authenticated;
      //notifyListeners();
    }
    //print(_loginStatus);
  }

  
  
  String _getError(e) {
  
    print(e);
    if (e.code == "ERROR_WRONG_PASSWORD") {
      //_loginError = LoginError.Password;
      return "Wrong Password";
    } else if (e.code == "ERROR_USER_NOT_FOUND") {
      //_loginError = LoginError.UserNotFound;
      return "Email not Registered";
    } else if (e.code == "ERROR_INVALID_EMAIL") {
      //_loginError = LoginError.InvalidEmail;
      return "Please enter your email in format abc@xyz.com";
    } else if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
      //_loginError = LoginError.AlreadyInUse;
      return "This email address belongs to someone else";
    } else if (e.code == "ERROR_WEAK_PASSWORD") {
      //_loginError = LoginError.Password;
      return "Kindly use Strong Password. Password Should be at least 6 Characters";
    } else if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
      //_loginError = LoginError.NetworkError;
      return "Unable to connect to Internet. Please connect to internet and try again";
    } else if (e.code == "ERROR_USER_DISABLED") {
      //_loginError = LoginError.Other;
      return "This user is disabled by Admin. Kindly contact Support by writing an Email to support";
    } else if (e.code == "ERROR_TOO_MANY_REQUESTS") {
      //_loginError = LoginError.Other;
      return "Too Many attempts from this device. Kindly try again later";
    } else {
      //_loginError = LoginError.Other;
      return "Unable to login right now. Kindly try again Later";
    }
  }
}

