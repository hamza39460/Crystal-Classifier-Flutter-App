import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'Result.dart';

class FirebaseDatabaseClass {
  final _db = FirebaseFirestore.instance;
  final _dbStorage =
      FirebaseStorage(storageBucket: 'gs://pashto-quran-app-demo.appspot.com');

  FirebaseDatabaseClass();

  addUserToDB(UserDescriptor user, File image) async {
    try {
      print('inner ${user.getUserDetails()}');
      Map<String, dynamic> data = user.getUserDetails();
      StorageUploadTask uploadTask = addProfileToDb(data['Email'], image);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      getUserRef(data['Email']).collection('Personal Info').doc().set({
        'Name': data['Name'],
        'Profile Image': imageUrl,
      });
      user.setImageUrl(imageUrl);
    } catch (e) {
      throw e;
    }
  }

  StorageUploadTask addProfileToDb(String email, File image) {
    String filePath = 'images/${email}_profile.png';
    return _dbStorage.ref().child(filePath).putFile(image);
  }

  getUserFromDB(String email, UserDescriptor user) async {
    try {
      QuerySnapshot querySnapshot =
          await getUserRef(email).collection('Personal Info').get();

      user = user.fromMap(querySnapshot.docs.first.data(), email);
    } catch (e) {
      throw e;
    }
  }

  DocumentReference getUserRef(String email) {
    return _db.collection('Users').doc(email);
  }

  createWorkSpace(WorkspaceDescriptor descriptor, String email) {
    try {
      DocumentReference documentReference =
          getUserRef(email).collection('Workspaces').doc();
      documentReference.set(descriptor.getAllDetails());
      descriptor.setFirebaseID(documentReference.id);
    } catch (e) {
      throw e;
    }
  }

  fetchAllWorkSpace(String email) async {
    try {
      var res = await getUserRef(email).collection('Workspaces').get();
      if (res != null) {
        List<DocumentSnapshot> workspaceList = res.docs;
        return workspaceList;
      }
      return null;
    } catch (e) {
      //print('${}')
      if (e == 'NoSuchMethodError')
        return null;
      else
        throw e;
    }
  }

  deleteWorkSpace(WorkspaceDescriptor workspaceDescriptor, String email) async {
    try {
      await getUserRef(email)
          .collection('Workspaces')
          .doc(workspaceDescriptor.getFirebaseId())
          .delete();
    } catch (e) {
      throw e;
    }
  }

  addResultToFirebase(Result result, UserDescriptor user,
      WorkspaceDescriptor workspaceDescriptor) async {
    try {
      DocumentReference documentReference = await getUserRef(user.getEmail())
          .collection('Workspaces')
          .doc(workspaceDescriptor.getFirebaseId())
          .collection('Results')
          .add(result.toJson());
      StorageUploadTask uploadTask = _addResultImageToFirebase(
          result.getImage(),
          workspaceDescriptor.getFirebaseId(),
          documentReference.id);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      result.setImageFirebasePath(imageUrl);
      await getUserRef(user.getEmail())
          .collection('Workspaces')
          .doc(workspaceDescriptor.getFirebaseId())
          .collection('Results')
          .doc(documentReference.id)
          .update({"Image Path": imageUrl});
    } catch (e) {
      throw e;
    }
  }

  StorageUploadTask _addResultImageToFirebase(
      File image, String workSpaceID, String resultID) {
    String filePath = 'images/$workSpaceID/${resultID}_image.png';
    return _dbStorage.ref().child(filePath).putFile(image);
  }

  getAllResults(
      WorkspaceDescriptor workspaceDescriptor, String userEmail) async {
    try {
      var res = await getUserRef(userEmail)
          .collection('Workspaces')
          .doc('${workspaceDescriptor.getFirebaseId()}')
          .collection('Results')
          .get();
      if (res != null) {
        List<DocumentSnapshot> workspaceList = res.docs;
        return workspaceList;
      }
      return null;
    } catch (e) {
      //print('${}')
      if (e == 'NoSuchMethodError')
        return null;
      else
        throw e;
    }
  }
}
