import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerSheet extends StatefulWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime fromDate, DateTime toDate) onSelect;
  const DatePickerSheet({Key? key, required this.fromDate, required this.toDate, required this.onSelect}) : super(key: key);

  @override
  _DatePickerSheetState createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  String _range = "";
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  DateRangePickerController controller = DateRangePickerController();
  @override
  void initState() {
    fromDate = widget.fromDate;
    toDate = widget.toDate;
    if (widget.fromDate != widget.toDate) {
      controller.selectedRange = PickerDateRange(widget.fromDate, widget.toDate);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            constraints: BoxConstraints(minHeight: 100, maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: SfDateRangePicker(
              controller: controller,
              initialDisplayDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              showActionButtons: true,
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (a) {
                widget.onSelect(fromDate, toDate);
                debugPrint(a.toString());
                Navigator.pop(context);
              },
              onSelectionChanged: (args) {
                debugPrint(args.toString());
                if (args.value is PickerDateRange) {
                  fromDate = args.value.startDate;
                  toDate = args.value.endDate ?? args.value.startDate;
                  _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} to'
                      ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
                } else if (args.value is DateTime) {
                  fromDate = args.value.startDate;
                  toDate = args.value.startDate;
                  _range = args.value.toString();
                }

                debugPrint(_range);
              },
            ),
          ),
        ],
      ),
    );
  }
}
