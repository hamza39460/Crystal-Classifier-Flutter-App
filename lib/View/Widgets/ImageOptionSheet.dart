import 'dart:io';

import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectOptionSheet {
  Function handlerFunction;
  BuildContext context;
  ImageSelectOptionSheet(
      {@required this.context, @required this.handlerFunction}) {
    (Platform.isIOS)
        ? showCupertinoModalPopup(
            context: context, builder: (BuildContext context) => sheet(context))
        : showDialog(
            context: context,
            builder: (BuildContext context) => sheet(context));
  }

  sheet(BuildContext context) {
    return (Platform.isIOS)
        ? CupertinoActionSheet(
            title: Text('Select Image Source'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Pick from Gallery'),
                onPressed: () async {
                  print('pick from gallery pressed');
                  Navigator.pop(context);
                  await handlerFunction(ImageSource.gallery);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Pick from Camera'),
                onPressed: () async {
                  print('pick from camera pressed');
                  Navigator.pop(context);
                  await handlerFunction(ImageSource.camera);
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Cancel'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          )
        : AlertDialog(
            title: Text('Select Image Source'),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  child: Text(
                    'Pick from Gallery',
                    style: TextStyle(fontSize: Common.getSPfont(17)),
                  ),
                  onPressed: () async {
                    print('pick from gallery pressed');
                    Navigator.pop(context);
                    await handlerFunction(ImageSource.gallery);
                  },
                ),
              ),
              Center(
                child: FlatButton(
                  child: Text(
                    'Pick from Camera',
                    style: TextStyle(fontSize: Common.getSPfont(17)),
                  ),
                  onPressed: () async {
                    print('pick from camera pressed');
                    Navigator.pop(context);
                    await handlerFunction(ImageSource.camera);
                  },
                ),
              ),
              Center(
                child: FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: Common.getSPfont(17)),
                  ),
                  //isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                ),
              ),
            ],
          );
  }
}
