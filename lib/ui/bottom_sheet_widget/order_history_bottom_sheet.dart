import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_widget.dart';

class OrderHistoryBottomSheet extends StatefulWidget {
  const OrderHistoryBottomSheet({Key? key}) : super(key: key);

  @override
  _OrderHistoryBottomSheetState createState() => _OrderHistoryBottomSheetState();
}

class _OrderHistoryBottomSheetState extends State<OrderHistoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: const [
              BottomSheetHeading("Summary"),
            ],
          ),
        );
      },
    );
  }
}
