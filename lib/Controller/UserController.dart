import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/Model/User.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  static final UserController _selfInstance = UserController._internal();
  static final User _user = User.init();
  UserAuthState _userAuthState = UserAuthState.Uninitialized;
  UserDataState _userDataState = UserDataState.Uninitialized;

  UserController._internal() {
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:43:26 
     * @Desc: Internal Constructor for UserController Class 
     */
  }

  factory UserController.init() {
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:45:35 
     * @Desc: Returns Instance of UserController class 
     */
    return _selfInstance;
  }

  loginWithEmailandPwd(String email, String pwd) async {
    _userAuthState = UserAuthState.Login_in_process;
    notifyListeners();
    bool response = await _user.loginWithEmailAndPwd(email, pwd);
    if (response == true) {
      //_userAuthState = UserAuthState.Authenticated;
      //notifyListeners();
      _fetchUserData(email);
    } else if (response == false) {
      _userAuthState = UserAuthState.Error;
      notifyListeners();
    }
  }

  _fetchUserData(String email) {
    _userDataState = UserDataState.Fetching_User_Data;
    notifyListeners();
    _user.getUserFromDB(email).then((value) {
      if (value == true)
        _userDataState = UserDataState.Fetched_User_Data;
      else
        _userDataState = UserDataState.Error;
      notifyListeners();
    });
  }

  signupWithEmailAndPwd(
      String name, String email, String pwd, File image) async {
    _userAuthState = UserAuthState.Signup_in_process;
    notifyListeners();
    bool response = await _user.signupWithEmailAndPwd(name, email, pwd);
    if (response == true) {
      _userDataState = UserDataState.Fetching_User_Data;
      notifyListeners();
      response = await _user.addUserToDB(image);
      if (response == true) {
        //_userAuthState = UserAuthState.Authenticated;
        _userDataState = UserDataState.Fetched_User_Data;
        notifyListeners();
      } else {
        _userAuthState = UserAuthState.Error;
        notifyListeners();
      }
    } else if (response == false) {
      _userAuthState = UserAuthState.Error;
      notifyListeners();
    }
    //notifyListeners
  }

  Future<bool> signOut() async {
    return await _user.signout();
  }

  bool updateUserDetails(String email, {String name, String pwd}) {}

  Map<String, String> getUserDetails() => _user.getUserDetails();

  UserDescriptor getUserDescriptor() => _user.getUserDescriptor();
  void setUserRef(DocumentReference documentReference) {}

  DocumentReference getUserDbRef() => _user.getUserDbRef();

  checkLoginState() async {
    if (await _user.checkLoginState() == true) {
      setUserAuthState(UserAuthState.Authenticated);
      _fetchUserData(await _user.getUserEmail());
    } else {
      setUserAuthState(UserAuthState.Unauthenticated);
    }
  }

  setUserAuthState(UserAuthState userAuthState) {
    this._userAuthState = userAuthState;
    notifyListeners();
  }

  setUserDataState(UserDataState userDataState) {
    this._userDataState = userDataState;
  }

  UserAuthState getUserAuthState() => this._userAuthState;

  UserDataState getUserDataState() => this._userDataState;
}
