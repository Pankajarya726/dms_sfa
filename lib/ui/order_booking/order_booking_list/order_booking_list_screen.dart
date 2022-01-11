import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class OrderBookingListScreen extends StatefulWidget {
  const OrderBookingListScreen({Key? key}) : super(key: key);

  @override
  _OrderBookingListScreenState createState() => _OrderBookingListScreenState();
}

class _OrderBookingListScreenState extends State<OrderBookingListScreen> {
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
    );
  }
}
