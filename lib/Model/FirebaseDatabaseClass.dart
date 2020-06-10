import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseDatabaseClass{
  final _db = Firestore.instance;
  final _dbStorage = FirebaseStorage(storageBucket: 'gs://pashto-quran-app-demo.appspot.com');

  FirebaseDatabaseClass();

  addUserToDB(UserDescriptor user,File image)async{
    try{
      print('inner $user');
      Map<String,dynamic> data=user.getUserDetails  ();
      StorageUploadTask uploadTask = addImageToDb(data['Email'], image);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _db.collection('Users').document(data['Email']).collection('Personal Info').document().setData(
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

   StorageUploadTask addImageToDb(String email,File image){
    String filePath = 'images/${email}_profile.png';
    return _dbStorage.ref().child(filePath).putFile(image);
  }

  getUserFromDB(String email,UserDescriptor user)async{
    try{
      QuerySnapshot querySnapshot = await  _db.collection('Users').document(email).collection('Personal Info').getDocuments();
      
      user=user.fromMap(querySnapshot.documents.first.data, email);
      
    }
    catch(e){
      throw e;
    }
  }
}