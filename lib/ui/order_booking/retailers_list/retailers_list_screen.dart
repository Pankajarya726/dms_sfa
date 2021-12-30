import 'package:dms/ui/order_booking/retailers_list/retailer_list_item.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class RetailerListScreen extends StatefulWidget {
  const RetailerListScreen({Key? key}) : super(key: key);

  @override
  _RetailerListScreenState createState() => _RetailerListScreenState();
}

class _RetailerListScreenState extends State<RetailerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          retailers,
          style: TextStyle(
            color: MColor.backButton,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: MColor.backButton,
          ),
        ),
      ),
      body: RetailerListItems(),
    );
  }
}
