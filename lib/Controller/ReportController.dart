import 'dart:developer';
import 'dart:typed_data';

import 'package:crystal_classifier/Model/Result.dart';
import 'package:crystal_classifier/Model/WorkspaceDescriptor.dart';
import 'package:intl/intl.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class ReportController {
  static final ReportController _selfInstance = ReportController._internal();
  List<Uint8List> _images = List();
  ReportController._internal();
  factory ReportController() {
    return _selfInstance;
  }
  generateReport(WorkspaceDescriptor workspace, List<Result> _results) async {
    final Document pdf = Document();
    for (Result result in _results) {
      _images.add(await _networkImageToByte(result.getImagePath()));
    }
    int _crystals = _count(_results, "Crystal");
    int _clear = _count(_results, "Clear");
    int _other = _count(_results, "Other");
    int _precipitate = _count(_results, "Precipitate");
    pdf.addPage(MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid,
                      color: PdfColor.fromInt(0xff131621),
                      width: 1.0)),
              child: Text('Workspace Report',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
              Header(
                  level: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Workspace Report', textScaleFactor: 2),
                        PdfLogo()
                      ])),
              Header(level: 3, text: 'Workspace Name: ${workspace.getName()}'),
              Header(
                  level: 3, text: 'Description: ${workspace.getDescription()}'),
              Header(
                  level: 3,
                  text: 'Workspace Created on: ${workspace.getCreationDate()}'),
              Header(level: 3, text: 'Total Crystals: $_crystals'),
              Header(level: 3, text: 'Total Clears: $_clear'),
              Header(level: 3, text: 'Total Others: $_other'),
              Header(level: 3, text: 'Total Precipitates: $_precipitate'),
              Header(level: 3, text: 'Report Created at: ${_getToday()}'),
              Padding(padding: const EdgeInsets.all(10)),
              Table(
                  border: TableBorder.ex(
                      bottom: BorderSide(), horizontalInside: BorderSide()),
                  children: [
                    TableRow(children: [
                      Text('Image'),
                      // Divider(),
                      Text('Time'),
                      // Divider(),
                      Text('Labal'),
                      // Divider(),
                      Text('Confidence')
                    ]),
                    for (int i = 0; i < _results.length; i++)
                      TableRow(children: [
                        Image.provider(MemoryImage(_images[i]),
                            height: 50, width: 50),
                        Text(_results[i].getDate()),
                        Text(_results[i].getClass()),
                        Text("${_results[i].getAccuracy()}"),
                      ])
                  ])
            ]));
    return pdf;
  }

  Future<Uint8List> _networkImageToByte(String url) async {
    Uint8List byteImage = await networkImageToByte('$url');

    return byteImage;
  }

  int _count(List<Result> _results, String _class) {
    int sum = 0;
    for (Result result in _results) {
      if (result.getClass() == _class) sum++;
    }
    return sum;
  }

  _getToday() {
    DateTime today = DateTime.now();
    return DateFormat('MMM d, yyyy').add_jm().format(today);
  }
}
