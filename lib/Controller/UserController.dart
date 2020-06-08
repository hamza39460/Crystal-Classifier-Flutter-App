import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Controller/States.dart';
import 'package:crystal_classifier/Model/User.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  static final UserController _selfInstance = UserController._internal();
  static final User _user =User.init();
  UserAuthState _userAuthState = UserAuthState.Uninitialized;
  

  UserController._internal(){
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:43:26 
     * @Desc: Internal Constructor for UserController Class 
     */
  }

  factory UserController.init(){
    /** 
     * @Author: hamza 
     * @Date: 2020-05-12 22:45:35 
     * @Desc: Returns Instance of UserController class 
     */
    return _selfInstance;
  }

  loginWithEmailandPwd(String email,String pwd)async{
    
    _userAuthState = UserAuthState.Login_in_process;
     notifyListeners();
    bool response = await _user.loginWithEmailAndPwd(email, pwd);
    if(response==true){
      _userAuthState = UserAuthState.Authenticated;
      notifyListeners();
    }  
    else if (response==false){
      _userAuthState = UserAuthState.Error;
      notifyListeners();
    }
  }

  signupWithEmailAndPwd(String name,String email,String pwd,File image) async {
    _userAuthState = UserAuthState.Signup_in_process;
    notifyListeners();
    //TODO  NOTIFY LISTENERS
    bool response = await _user.signupWithEmailAndPwd(name,email, pwd, image);
    if(response==true){
      _userAuthState = UserAuthState.Authenticated;
    notifyListeners();
    }  
    else if (response==false){
      _userAuthState = UserAuthState.Error;
      notifyListeners();
    }
    //notifyListeners
  }

  bool updateUserDetails(String email,{String name, String pwd}){

  }

  void setUserRef(DocumentReference documentReference){

  }

  DocumentReference getUserDbRef(){

  }

  setUserAuthState(UserAuthState userAuthState){
    this._userAuthState=userAuthState;
    notifyListeners();
  }

  UserAuthState getUserAuthState()=>this._userAuthState;


}