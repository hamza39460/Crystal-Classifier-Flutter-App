import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Controller/FirebaseController.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';

class User {
  UserDescriptor _userDetails;
  DocumentReference _userRef;
  static final FirebaseController _firebaseController =  FirebaseController.init();
  
  User.init();

  Future<bool> loginWithEmailAndPwd(String email,String pwd) async {
    bool response =await _firebaseController.loginWithEmailAndPwd(email, pwd);
    return response;
    
  }

  Future<bool> signupWithEmailAndPwd(String name,String email,String pwd) async{
    bool response = await _firebaseController.signUpWithEmailAndPassword(email, pwd);
    if(response==true){
      _userDetails=UserDescriptor.init(name, email);
    }
    return response;

  }

  Future<bool> getUserFromDB(email) async {
      _userDetails=UserDescriptor();
      bool response = await _firebaseController.getUserFromDB(_userDetails, email,);

      print("User: ${_userDetails.getUserDetails()}");
      print("USER REF: ${_userRef.toString()}");
      return response;
  }

  Future<bool> addUserToDB(File image) async{
    bool response = await _firebaseController.addUserToDb(_userDetails, image,);
    return response;
  }

  bool updateUserDetails(String email,{String name, String pwd}){

  }

   Future<bool> signout()async{
    return await _firebaseController.signout();
  }

  void setUserRef(DocumentReference documentReference){

  }

  DocumentReference getUserDbRef()=>_userRef;

  String getImageUrl()=>_userDetails.getImageUrl();

  Map<String, String>getUserDetails()=>_userDetails.getUserDetails();
}