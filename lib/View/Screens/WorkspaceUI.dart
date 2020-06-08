import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/ExpandTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class WorkspaceUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return Scaffold(
      body: _bodyStack(context),
    );
  }

  _bodyStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundWidget(),
        _bodyColumn(context),
      ],
    );
  }

  _bodyColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: AppTitle(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'ABC',
                    style: TextStyle(
                        fontSize: Common.getSPfont(26),
                        fontWeight: FontWeight.bold,
                        color: whiteColor),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: whiteColor,
                      ),
                      onPressed: () {
                        AppRoutes.bottomSheetOpen(
                            context, _optionsBottomSheet(),
                            isDismissible: true);
                      }),
                ],
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: ExpandedText(
                    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu,',
                    trimLines: 2,
                    trimCollapsedText: '...Read more',
                    colorClickableText: whiteColor,
                    trimExpandedText: '...Less',
                    trimMode: TrimMode.Line,
                    style: TextStyle(
                        fontSize: Common.getSPfont(15), color: whiteColor),
                  ),
                )),
            _imagesGrid(),
          ],
        ),
      ),
    );
  }
}

class _imagesGrid extends StatefulWidget {
  @override
  __imagesGridState createState() => __imagesGridState();
}

class __imagesGridState extends State<_imagesGrid> {
  final _images = [
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
    'assets/images/crystalImage.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: _images.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          primary: false,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              //height: 20,
              //width: MediaQuery.of(context).size.width*0.8,
              padding: const EdgeInsets.all(10),
              child: GridTile(
                child: Image.asset(
                  _images[index],
                  height: MediaQuery.of(context).size.height,
                  width: 150,
                ),
                footer: Container(
                  height: ScreenUtil().setHeight(150),
                  width: 150,
                  color: Colors.white,
                  child: ListTile(
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Clear',
                        style: new TextStyle(
                            fontSize: Common.getSPfont(18),
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    //trailing: IconButton(icon: Icon(Icons.navigate_next),),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class _optionsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardBackground(
      child: Column(
        //shrinkWrap: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton.icon(
            onPressed: () {
              print('Generate Report Pressed');
            },
            icon: Icon(Icons.insert_drive_file),
            label: Text(
              'Generate Report',
              style: TextStyle(
                  fontSize: Common.getSPfont(18),
                  color: blackColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton.icon(
            onPressed: () {
              print('Edit Workspace Pressed');
            },
            icon: Icon(
              Icons.edit,
            ),
            label: Text(
              'Edit Workspace',
              style: TextStyle(
                  fontSize: Common.getSPfont(18),
                  color: blackColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton.icon(
            onPressed: () {
              print('Delete workspace Pressed');
            },
            icon: Icon(Icons.delete),
            label: Text(
              'Generate Report',
              style: TextStyle(
                  fontSize: Common.getSPfont(18),
                  color: blackColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
