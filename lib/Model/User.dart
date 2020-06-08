import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Controller/FirebaseController.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';

class User {
  UserDescriptor _userDetails;
  DocumentReference userRef;
  static final FirebaseController _firebaseController =  FirebaseController.init();
  
  User.init();

  Future<bool> loginWithEmailAndPwd(String email,String pwd) async {
    bool response =await _firebaseController.loginWithEmailAndPwd(email, pwd);
    if(response==true){
      _userDetails=UserDescriptor();
      response = await _firebaseController.getUserFromDB(_userDetails, email);
      print("User: $_userDetails");
    }

    return response;
    
  }

  Future<bool> signupWithEmailAndPwd(String name,String email,String pwd,File image) async{
    bool response = await _firebaseController.signUpWithEmailAndPassword(email, pwd);
    if(response==true){
      _userDetails=UserDescriptor.init(name, email);
      response = await _firebaseController.addUserToDb(_userDetails, image);
    }
    return response;

  }

  bool updateUserDetails(String email,{String name, String pwd}){

  }

  void setUserRef(DocumentReference documentReference){

  }

  DocumentReference getUserDbRef(){

  }
}