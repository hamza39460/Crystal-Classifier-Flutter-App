import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';


class FirebaseDatabaseClass{
  final _db = Firestore.instance;
  final _dbStorage = FirebaseStorage(storageBucket: 'gs://pashto-quran-app-demo.appspot.com');

  FirebaseDatabaseClass();

  addUserToDB(UserDescriptor user,File image,DocumentReference userRef)async{
    try{
      print('inner ${user.getUserDetails()}');
      Map<String,dynamic> data=user.getUserDetails();
      StorageUploadTask uploadTask = addProfileToDb(data['Email'], image);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      userRef = _db.collection('Users').document(data['Email']);
      userRef.collection('Personal Info').document().setData(
      {
      'Name':data['Name'],
      'Profile Image':imageUrl,
      }
    );
    user.setImageUrl(imageUrl);
    }
    catch(e)
    {
      
      throw e;
    }
  }

   StorageUploadTask addProfileToDb(String email,File image){
    String filePath = 'images/${email}_profile.png';
    return _dbStorage.ref().child(filePath).putFile(image);
  }

  getUserFromDB(String email,UserDescriptor user,DocumentReference userRef)async{
    try{
      userRef = _db.collection('Users').document(email);
      QuerySnapshot querySnapshot = await userRef.collection('Personal Info').getDocuments();
      
      user=user.fromMap(querySnapshot.documents.first.data, email);
      

    }
    catch(e){
      throw e;
    }
  }


  createWorkSpace(WorkspaceDescriptor descriptor,DocumentReference userDB){
    try{
      userDB.collection('Workspaces').document().setData(
        descriptor.getAllDetails()
      );
    }
    catch(e){
      throw e;
    }
    
  }

  fetchAllWorkSpace(DocumentReference userDB) async {
    try{
       var res = await userDB.collection('Workspaces').getDocuments();
       List<DocumentSnapshot> workspaceList = res.documents;
       return workspaceList;  
    }
    catch(e){
        throw e;
    }
  }

}