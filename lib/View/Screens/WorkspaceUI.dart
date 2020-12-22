import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:crystal_classifier/Controller/AnalyzeController.dart';
import 'package:crystal_classifier/Controller/ReportController.dart';
import 'package:crystal_classifier/Controller/ResultController.dart';
import 'package:crystal_classifier/Controller/UserController.dart';
import 'package:crystal_classifier/Controller/WorkspaceController.dart';
import 'package:crystal_classifier/Model/Result.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:crystal_classifier/View/Screens/CreateWorkspace_Sheet.dart';
import 'package:crystal_classifier/View/Screens/DeleteAlertScreen.dart';
import 'package:crystal_classifier/View/Screens/ReportViewerUI.dart';
import 'package:crystal_classifier/View/Screens/ResultUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/appRoutes.dart';
import 'package:crystal_classifier/View/Widgets/AppTitle.dart';
import 'package:crystal_classifier/View/Widgets/BackButtonWidget.dart';
import 'package:crystal_classifier/View/Widgets/Background.dart';
import 'package:crystal_classifier/View/Widgets/CardBackground.dart';
import 'package:crystal_classifier/View/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:crystal_classifier/View/Widgets/CircularWidgetDialogWidget.dart';
import 'package:crystal_classifier/View/Widgets/ExpandTextWidget.dart';
import 'package:crystal_classifier/View/Widgets/ImageOptionSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfwid;

class WorkspaceUI extends StatefulWidget {
  final WorkspaceDescriptor _workspaceDescriptor;

  WorkspaceUI({@required WorkspaceDescriptor workspaceDescriptor})
      : this._workspaceDescriptor = workspaceDescriptor;

  @override
  _WorkspaceUIState createState() => _WorkspaceUIState();
}

class _WorkspaceUIState extends State<WorkspaceUI> {
  final ResultController _resultController = ResultController();

  @override
  void initState() {
    _resultController.getAllResults(widget._workspaceDescriptor,
        UserController.init().getUserDescriptor().getEmail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Common.ScreenInit(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Analyze Image',
          style: TextStyle(
              fontSize: Common.getSPfont(13),
              color: mosqueColor1,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: whiteColor,
        onPressed: () {
          _addNewPressed(context);
        },
      ),
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
      padding: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
                child: Row(
              children: [
                BackButtonWidget(),
                AppTitle(),
              ],
            )),
            _showWorkspaceName(context),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: ExpandedText(
                    widget._workspaceDescriptor.getDescription(),
                    trimLines: 2,
                    trimCollapsedText: '...Read more',
                    colorClickableText: whiteColor,
                    trimExpandedText: '...Less',
                    trimMode: TrimMode.Line,
                    style: TextStyle(
                        fontSize: Common.getSPfont(15), color: whiteColor),
                  ),
                )),
            _result(),
          ],
        ),
      ),
    );
  }

  Widget _showWorkspaceName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget._workspaceDescriptor.getName(),
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
                    context,
                    _OptionsBottomSheet(
                      workspaceDescriptor: this.widget._workspaceDescriptor,
                      then: () {
                        setState(() {});
                      },
                      results: _resultController.getResultList(),
                    ),
                    isDismissible: true);
              }),
        ],
      ),
    );
  }

  void _addNewPressed(BuildContext context) {
    ImageSelectOptionSheet(
        context: context,
        handlerFunction: (ImageSource src) async {
          PickedFile image =
              await ImagePicker().getImage(source: src, imageQuality: 80);
          if (image != null) {
            CircularWidgetDialog()
                .showLoadingDialog(context, message: "Classifying the Image");
            AnalyzeController analyzeController = AnalyzeController.init();
            bool analyzed = await analyzeController.analyze(File(image.path));
            log('analyzed $analyzed');
            if (analyzed == true) {
              await _resultController.addResult(
                  analyzeController.getResult(),
                  UserController.init().getUserDescriptor(),
                  this.widget._workspaceDescriptor);
              log('abc');

              setState(() {
                _resultController
                    .getResultList()
                    .add(analyzeController.getResult());
                _resultController
                    .getStreamController()
                    .add(ResultState.Fetched);
              });
            }
            CircularWidgetDialog().hideLoadingDialog();
          }
        });
  }

  _result() {
    return StreamBuilder(
      stream: _resultController.getStreamController().stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Common.message("An error Occured.", context);
        }
        if (!snapshot.hasData || snapshot.data == ResultState.Fetching) {
          return CircularProgressIndicatorWidget();
        }
        if (snapshot.hasData && snapshot.data == ResultState.Fetched) {
          return _ImagesGrid(
            results: _resultController.getResultList(),
            workspaceDescriptor: widget._workspaceDescriptor,
          );
        }
        if (snapshot.hasData && snapshot.data == ResultState.NoData) {
          return Container(
            child: Column(
              children: [
                Center(
                  child: Image.asset('assets/images/bookIcon.png'),
                ),
                Common.message("No Image Found", context),
              ],
            ),
          );
        }
      },
    );
  }
}

class _ImagesGrid extends StatefulWidget {
  final List<Result> results;
  final WorkspaceDescriptor workspaceDescriptor;
  _ImagesGrid({this.results, this.workspaceDescriptor});
  @override
  _ImagesGridState createState() => _ImagesGridState();
}

class _ImagesGridState extends State<_ImagesGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: widget.results.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          primary: false,
          itemBuilder: (BuildContext context, int index) {
            Result result = widget.results[index];
            return InkWell(
              onTap: () {
                AppRoutes.push(
                    context,
                    ResultUI(
                      workspaceDescriptor: widget.workspaceDescriptor,
                      result: result,
                    ));
              },
              child: Container(
                //height: 20,
                //width: MediaQuery.of(context).size.width*0.8,
                padding: const EdgeInsets.all(10),
                child: GridTile(
                  child: Image.network(
                    result.getImagePath(),
                    height: 150,
                    width: 150,
                    fit: BoxFit.fitWidth,
                  ),
                  footer: Container(
                    height: ScreenUtil().setHeight(150),
                    width: 150,
                    color: Colors.white.withOpacity(0.7),
                    child: ListTile(
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${result.getClass()}',
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
              ),
            );
          }),
    );
  }
}

class _OptionsBottomSheet extends StatelessWidget {
  WorkspaceDescriptor workspaceDescriptor;
  Function then;
  List<Result> results;
  _OptionsBottomSheet({this.workspaceDescriptor, this.results, this.then});
  @override
  Widget build(BuildContext context) {
    return CardBackground(
      child: Column(
        //shrinkWrap: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: FlatButton.icon(
              onPressed: () async {
                CircularWidgetDialog().showLoadingDialog(context,
                    message: "Generating the Report");
                final pdfwid.Document pdf = await ReportController()
                    .generateReport(this.workspaceDescriptor, this.results);
                CircularWidgetDialog().hideLoadingDialog();
                final output = await getTemporaryDirectory();
                final file = File("${output.path}/report.pdf");
                await file.writeAsBytes(pdf.save());
                //OpenFile.open("${output.path}/report.pdf");
                CircularWidgetDialog().hideLoadingDialog();
                AppRoutes.push(
                    context,
                    ReportViewerUI(
                      name: this.workspaceDescriptor.getName(),
                      path: "${output.path}/report.pdf",
                      pdf: pdf,
                    ));
                CircularWidgetDialog().hideLoadingDialog();
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
          ),
          Divider(
            color: greyColor3,
            //height: 10,
          ),
          Container(
            width: double.infinity,
            child: FlatButton.icon(
              onPressed: () {
                AppRoutes.pop(context);
                AppRoutes.bottomSheetOpenWithThen(
                    context,
                    CreateWorkSpaceUI(
                      workspaceDescriptor: workspaceDescriptor,
                    ), () {
                  this.then();
                });
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
          ),
          Divider(
            color: greyColor3,
            //height: 10,
          ),
          Container(
            width: double.infinity,
            child: FlatButton.icon(
              onPressed: () {
                print('Delete workspace Pressed');
                AppRoutes.pop(context);
                AppRoutes.push(
                    context,
                    DeleteAlertScreen(
                      workspaceDescriptor: workspaceDescriptor,
                    ),
                    opaque: false);
              },
              icon: Icon(Icons.delete),
              label: Text(
                'Delete Workspace',
                style: TextStyle(
                    fontSize: Common.getSPfont(18),
                    color: blackColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
