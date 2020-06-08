import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectOptionSheet {
  Function handlerFunction;
  BuildContext context;
  ImageSelectOptionSheet({@required this.context,@required this.handlerFunction}) {
    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => sheet(context));
  }

  sheet(BuildContext context) {
    return CupertinoActionSheet(
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
    );
  }
}
