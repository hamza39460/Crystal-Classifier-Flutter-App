import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/Model/FirebaseAuthClass.dart';
import 'package:crystal_classifier/Model/FirebaseDatabaseClass.dart';
import 'package:crystal_classifier/Model/Result.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crystal_classifier/View/Widgets/CustomSnackbar.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseController {
  static final FirebaseController _selfInstance =
      FirebaseController._internal();

  static FirebaseAuthClass _firebaseAuth;
  static FirebaseDatabaseClass _firebaseDatabase = FirebaseDatabaseClass();

  FirebaseController._internal() {
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:43:26 
     * @Desc: Internal Constructor for UserController Class 
     */

    _firebaseAuth = FirebaseAuthClass(_authStateChanged);
  }

  factory FirebaseController.init() {
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
      CustomSnackbar().showError('Login in error $e');
      print('sign in error $e');
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signUpWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      //String _message = _getError(e);
      CustomSnackbar().showError('Signup error $e');
      print('signup error $e');
      return false;
      //notifyListeners();
      //_showError();
    }
  }

  Future<bool> addUserToDb(UserDescriptor user, File image) async {
    try {
      await _firebaseDatabase.addUserToDB(user, image);
      return true;
    } catch (e) {
      print('Adding user to DB Error $e');
      return false;
    }
  }

  Future<bool> getUserFromDB(UserDescriptor user, String email) async {
    try {
      await _firebaseDatabase.getUserFromDB(email, user);
      print("User01: ${user.getUserDetails()}");
      return true;
    } catch (e) {
      print('Getting user from DB error $e ');
      return false;
    }
  }

  Future<bool> signout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      String _message = _getError(e);
      CustomSnackbar().showError(_message);
      print('signup error $e');
      return false;
    }
  }

  Future<bool> updateUserDetails(
      String email, String name, String password, File image) {
    //TODO
  }

  Future<bool> createWorkSpace(
      WorkspaceDescriptor descriptor, String email) async {
    try {
      await _firebaseDatabase.createWorkSpace(descriptor, email);
      return true;
    } catch (e) {
      print('Create Workspace error $e');
      CustomSnackbar().showError('Error $e');
      return false;
    }
  }

  Future<bool> fetchAllWorkspaces(
      List<WorkspaceDescriptor> workSpaceList, String email) async {
    try {
      List<DocumentSnapshot> workspaceList =
          await _firebaseDatabase.fetchAllWorkSpace(email);
      if (workSpaceList != null)
        for (DocumentSnapshot workspaceSnapshot in workspaceList) {
          WorkspaceDescriptor workspace = WorkspaceDescriptor.previous(
              workspaceSnapshot.id,
              workspaceSnapshot.data()['Name'],
              workspaceSnapshot.data()['Description'],
              workspaceSnapshot.data()['Created on']);
          workSpaceList.add(workspace);
        }
      return true;
    } catch (e) {
      print('Get all workspace error $e');
      CustomSnackbar().showError('Error $e');
      return false;
    }
  }

  Future<bool> updateWorkspace(
      WorkspaceDescriptor workspaceDescriptor, String email) async {
    try {
      await _firebaseDatabase.updateWorkSpace(workspaceDescriptor, email);
      return true;
    } catch (e) {
      print('Updating Workspace error $e');
      CustomSnackbar().showError('Error $e');
      return false;
    }
  }

  Future<bool> deleteWorkspace(
      WorkspaceDescriptor workspaceDescriptor, String email) async {
    try {
      await _firebaseDatabase.deleteWorkSpace(workspaceDescriptor, email);
      return true;
    } catch (e) {
      print('deleting workspace error $e');
      CustomSnackbar().showError('Error $e');
      return false;
    }
  }

  addResultToFirebase(Result result, UserDescriptor user,
      WorkspaceDescriptor workspaceDescriptor) async {
    try {
      await _firebaseDatabase.addResultToFirebase(
          result, user, workspaceDescriptor);

      return true;
    } catch (e) {
      print('adding result error $e');
      CustomSnackbar().showError('Error $e');
      return false;
    }
  }

  Future<List> getAllResults(
      WorkspaceDescriptor workspaceDescriptor, String userEmail) async {
    List<Result> results = List();
    try {
      List<DocumentSnapshot> resultsList =
          await _firebaseDatabase.getAllResults(workspaceDescriptor, userEmail);
      if (resultsList != null) {
        for (DocumentSnapshot result in resultsList) {
          results.add(Result.fromJson(result.data()));
        }
      }
      return results;
    } catch (e) {
      log('fetching Results Error $e');
      CustomSnackbar().showError('Error $e');
      throw e;
    }
  }

  Future<bool> checkLoginState() async {
    return await _firebaseAuth.loginState();
  }

  Future<String> getUserEmail() async {
    User user = await _firebaseAuth.getCurrentUser();
    return user.email;
  }

  Future<void> _authStateChanged(User user) async {
    if (user == null) {
      UserController.init().setUserAuthState(UserAuthState.Unauthenticated);
      WorkSpaceController.init()
          .setWorkspaceState(WorkspaceState.Uninitialized);
      UserController.init().setUserDataState(UserDataState.Uninitialized);
    } else {
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
