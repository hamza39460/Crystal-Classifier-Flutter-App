import 'package:crystal_classifier/Controller/ReportController.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:crystal_classifier/View/Utils/Common.dart';
import 'package:crystal_classifier/View/Utils/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets/document.dart';
import 'package:printing/printing.dart';

class ReportViewerUI extends StatelessWidget {
  String path;
  final Document pdf;
  String name;
  ReportViewerUI({this.name, this.path, this.pdf});
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          backgroundColor: mosqueColor1,
          leading: InkWell(
            child: Icon(Icons.navigate_before, size: Common.getSPfont(25)),
            onTap: () {
              AppRoutes.pop(context);
            },
          ),
          title: Text(
            'Report',
            style: TextStyle(fontSize: Common.getSPfont(20)),
          ),
          actions: [
            InkWell(
              child: Icon(Icons.share_outlined, size: Common.getSPfont(25)),
              onTap: () async {
                await ReportController().shareReport(pdf, "$name.pdf");
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
            ),
            InkWell(
                child: Icon(Icons.print, size: Common.getSPfont(25)),
                onTap: () async {
                  //await Printing.
                  await ReportController().printReport(pdf);
                }),
            Padding(
              padding: const EdgeInsets.all(5),
            ),
          ],
        ),
        path: this.path);
  }
}
