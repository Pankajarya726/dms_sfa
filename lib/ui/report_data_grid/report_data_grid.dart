import 'dart:developer';
import 'dart:io';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sfa/listeners/report_type_listener.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:sfa/ui/report_screen/model/report_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class ReportDataGrid extends StatefulWidget {
  final Function(ReportTypeListener reportTypeListener) onTypeSelect;
  List<ReportData>? reportData;
  ReportDataGrid(
      {Key? key, required this.reportData, required this.onTypeSelect})
      : super(key: key);

  @override
  _ReportDataGridState createState() => _ReportDataGridState();
}

class _ReportDataGridState extends State<ReportDataGrid>
    implements ReportTypeListener {
  ReportDataSource? reportDataSource;
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    reportDataSource = ReportDataSource(reportData: widget.reportData!);
    widget.onTypeSelect(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfDataGrid(
        key: key,
        source: reportDataSource!,
        highlightRowOnHover: true,
        isScrollbarAlwaysShown: false,
        columnWidthMode: ColumnWidthMode.auto,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columns: <GridColumn>[
          GridColumn(
              columnName: 'Name',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Name"))),
          GridColumn(
              columnName: 'Designation',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Designation"))),
          GridColumn(
              columnName: 'Mobile No',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Mobile No"))),
          GridColumn(
              columnName: 'Date',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Date"))),
          GridColumn(
              columnName: 'Clock In Time',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Clock In Time"))),
          GridColumn(
              columnName: 'Clock Out Time',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Clock Out Time"))),
          GridColumn(
              columnName: 'PJP',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("PJP"))),
          GridColumn(
              columnName: 'Working Plan',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Working Plan"))),
          GridColumn(
              columnName: 'Comment',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Comment"))),
          GridColumn(
              columnName: 'Attendance Status',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Attendance Status"))),
          GridColumn(
              columnName: 'Status Approved',
              label: Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text("Status Approved"))),
        ],
      ),
    );
  }

  Future<void> exportDataGridToExcel() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      Directory? directory;
      directory = await DownloadsPathProvider.downloadsDirectory;
      String path = directory!.path +
          DateFormat("/dd MMM yyyy hh mm ss").format(DateTime.now()) +
          ".xlsx";
      log(path);
      final xlsio.Workbook workbook = key.currentState!.exportToExcelWorkbook();
      final List<int> bytes = workbook.saveAsStream();
      File(path).writeAsBytes(bytes);
      workbook.dispose();
      Fluttertoast.showToast(msg: "File Saved " + path);
    }
    if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> exportDataGridToPdf() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      Directory? directory;
      directory = await DownloadsPathProvider.downloadsDirectory;
      String path = directory!.path +
          DateFormat("/dd MMM yyyy hh mm ss").format(DateTime.now()) +
          ".pdf";
      log(path);
      final PdfDocument document =
          key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
      final List<int> bytes = document.save();
      File(path).writeAsBytes(bytes);
      document.dispose();
      Fluttertoast.showToast(msg: "File Saved " + path);
    }
    if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void onTypeSelect(String reportType) {
    if (reportType == "0") {
      exportDataGridToExcel();
    }
    if (reportType == "1") {
      exportDataGridToPdf();
    }
  }
}

class ReportDataSource extends DataGridSource {
  ReportDataSource({required List<ReportData> reportData}) {
    _reportData = reportData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Name', value: e.name),
              DataGridCell<String>(
                  columnName: 'Designation', value: e.designation),
              DataGridCell<String>(
                  columnName: 'Mobile No', value: e.primaryContactNo),
              DataGridCell<String>(columnName: 'Date', value: e.date),
              DataGridCell<String>(
                  columnName: 'Clock In Time', value: e.clockInTime),
              DataGridCell<String>(
                  columnName: 'Clock Out Time', value: e.clockOutTime),
              DataGridCell<String>(columnName: 'PJP', value: e.pjp),
              DataGridCell<String>(
                  columnName: 'Working Plan', value: e.workingPlan),
              DataGridCell<String>(columnName: 'Comment', value: e.comment),
              DataGridCell<String>(
                  columnName: 'Attendance Status',
                  value: e.attendanceStatus == "3" ? "Absent" : "Present"),
              DataGridCell<String>(
                  columnName: 'Status Approved',
                  value: e.statusApproved == "1"
                      ? "Pending"
                      : e.workingPlan == "2"
                          ? "Approved"
                          : e.workingPlan == "3"
                              ? "Rejected"
                              : ""),
            ]))
        .toList();
  }

  List<DataGridRow> _reportData = [];

  @override
  List<DataGridRow> get rows => _reportData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
