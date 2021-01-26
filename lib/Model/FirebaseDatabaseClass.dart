import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_classifier/Model/FirebaseAuthClass.dart';
import 'package:crystal_classifier/Model/UserDescriptor.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'Result.dart';

class FirebaseDatabaseClass {
  final _db = FirebaseFirestore.instance;
  final _dbStorage =
      FirebaseStorage(storageBucket: 'gs://pashto-quran-app-demo.appspot.com');

  FirebaseDatabaseClass();

  addUserToDB(UserDescriptor user, File image, User firebaseUser) async {
    try {
      //print('inner ${user.getUserDetails()}');
      Map<String, dynamic> data = user.getUserDetails();
      StorageUploadTask uploadTask = addProfileToDb(firebaseUser.uid, image);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      getUserRef(firebaseUser.uid).collection('Personal Info').doc().set({
        'Name': data['Name'],
        'Profile Image': imageUrl,
      });
      user.setImageUrl(imageUrl);
    } catch (e) {
      throw e;
    }
  }

  StorageUploadTask addProfileToDb(String userID, File image) {
    String filePath = 'images/${userID}_profile.png';

    return _dbStorage.ref().child(filePath).putFile(image);
  }

  getUserFromDB(User firebaseUser, UserDescriptor user) async {
    try {
      QuerySnapshot querySnapshot =
          await getUserRef(firebaseUser.uid).collection('Personal Info').get();

      user = user.fromMap(querySnapshot.docs.first.data(), firebaseUser.email);
    } catch (e) {
      throw e;
    }
  }

  DocumentReference getUserRef(String uid) {
    return _db.collection('Users').doc(uid);
  }

  createWorkSpace(WorkspaceDescriptor descriptor, User firebaseUser) {
    try {
      DocumentReference documentReference =
          getUserRef(firebaseUser.uid).collection('Workspaces').doc();
      documentReference.set(descriptor.getAllDetails());
      descriptor.setFirebaseID(documentReference.id);
    } catch (e) {
      throw e;
    }
  }

  updateWorkSpace(WorkspaceDescriptor workspaceDescriptor, User user) async {
    try {
      await getUserRef(user.uid)
          .collection('Workspaces')
          .doc(workspaceDescriptor.getFirebaseId())
          .update(workspaceDescriptor.getAllDetails());
    } catch (e) {
      throw e;
    }
  }

  fetchAllWorkSpace(User firebaseUser) async {
    try {
      var res =
          await getUserRef(firebaseUser.uid).collection('Workspaces').get();
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

  deleteWorkSpace(
      WorkspaceDescriptor workspaceDescriptor, User firebaseUser) async {
    try {
      await getUserRef(firebaseUser.uid)
          .collection('Workspaces')
          .doc(workspaceDescriptor.getFirebaseId())
          .delete();
    } catch (e) {
      throw e;
    }
  }

  addResultToFirebase(Result result, User firebaseUser,
      WorkspaceDescriptor workspaceDescriptor) async {
    try {
      DocumentReference documentReference = await getUserRef(firebaseUser.uid)
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
      await getUserRef(firebaseUser.uid)
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
      WorkspaceDescriptor workspaceDescriptor, User firebaseUser) async {
    try {
      var res = await getUserRef(firebaseUser.uid)
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

  Future<void> updateNameImage(UserDescriptor user, String newName,
      File newImage, User firebaseUser) async {
    try {
      var imageUrl;
      log('id ${firebaseUser.uid}');
      if (newImage != null) {
        StorageUploadTask uploadTask =
            addProfileToDb(firebaseUser.uid, newImage);

        imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        user.setImageUrl(imageUrl);
      }

      QuerySnapshot snapshot =
          await getUserRef(firebaseUser.uid).collection('Personal Info').get();
      log('name $newName');
      getUserRef(firebaseUser.uid)
          .collection('Personal Info')
          .doc(snapshot.docs.first.id)
          .update({
        'Name': newName,
        'Profile Image': imageUrl == null ? user.getImageUrl() : imageUrl,
      });
    } catch (e) {
      throw e;
    }
  }
}
