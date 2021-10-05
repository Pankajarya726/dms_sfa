import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:sfa/utility/colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isPressed1 = false;
  bool isPressed2 = false;
  bool isPressed3 = false;
  bool isPressed4 = false;
  bool accordionStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        title: const Text(
          "Report",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              showFilters();
            },
            icon: const Image(
              height: 100,
              width: 100,
              image: AssetImage("assets/filter.png"),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(125),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(color: colorGrayDark),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (isPressed1 == true) {
                                isPressed1 != isPressed1;
                              } else {
                                isPressed1 = !isPressed1;
                                isPressed2 = false;
                                isPressed3 = false;
                                isPressed4 = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.1845,
                              decoration: BoxDecoration(
                                color: isPressed1 ? colorPrimary : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 13,
                                    width: 13,
                                    child: Image.asset(
                                      "assets/custom-calendar.png",
                                      color: isPressed1
                                          ? Colors.white
                                          : colorGrayDark,
                                    ),
                                  ),
                                  Text(
                                    "Custom",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: isPressed1
                                            ? Colors.white
                                            : colorGrayDark),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (isPressed2 == true) {
                                isPressed1 != isPressed1;
                              } else {
                                isPressed1 = false;
                                isPressed2 = !isPressed2;
                                isPressed3 = false;
                                isPressed4 = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                color: isPressed2 ? colorPrimary : Colors.white,
                                border: const Border(
                                  left:
                                      BorderSide(color: colorGray, width: 1.0),
                                  right:
                                      BorderSide(color: colorGray, width: 1.0),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "7 Days",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: isPressed2
                                            ? Colors.white
                                            : colorGrayDark),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (isPressed3 == true) {
                                isPressed1 != isPressed1;
                              } else {
                                isPressed1 = false;
                                isPressed2 = false;
                                isPressed3 = !isPressed3;
                                isPressed4 = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                color: isPressed3 ? colorPrimary : Colors.white,
                                border: const Border(
                                  right:
                                      BorderSide(color: colorGray, width: 1.0),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "15 Days",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: isPressed3
                                            ? Colors.white
                                            : colorGrayDark),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (isPressed4 == true) {
                                isPressed1 != isPressed1;
                              } else {
                                isPressed1 = false;
                                isPressed2 = false;
                                isPressed3 = false;
                                isPressed4 = !isPressed4;
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                color: isPressed4 ? colorPrimary : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "30 Days",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: isPressed4
                                            ? Colors.white
                                            : colorGrayDark),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 32,
                        width: MediaQuery.of(context).size.width * 0.23,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset("assets/download.png"),
                            const Text(
                              "All Staff",
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: reportBG,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            style: const TextStyle(
                                color: colorGrayDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            autocorrect: true,
                            enableSuggestions: true,
                            maxLines: 1,
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.search,
                                  color: colorGray,
                                ),
                              ),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: colorGrayLite,
                              hintText: "Search",
                              hintStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: colorGray),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 1,
                          child: Container(
                            margin: const EdgeInsets.only(top: 3),
                            height: 44,
                            width: 5,
                            decoration: const BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(300.0),
                                bottomLeft: Radius.circular(300.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        color: reportBG,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              10,
              (index) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: -10,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: GFAccordion(
                    onToggleCollapsed: (expand) {
                      accordionStatus = expand;
                      setState(() {});
                    },
                    showAccordion: accordionStatus,
                    titleBorderRadius: !accordionStatus
                        ? BorderRadius.circular(5)
                        : const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                    contentBorderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    expandedTitleBackgroundColor: Colors.white,
                    contentBackgroundColor: Colors.white,
                    contentPadding: const EdgeInsets.all(0),
                    titleChild: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Oliver",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 3),
                            Text("31 Aug 2021 - 14 Sep 2021",
                                style: TextStyle(
                                    color: Color(0xff555555),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.only(right: 7),
                            child: Image.asset("assets/download-bg.png",
                                width: 27, fit: BoxFit.contain),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    contentChild: Column(
                      children: [
                        const Divider(height: 1, color: Color(0xff898989)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                    text: "Full Day : ",
                                    style: TextStyle(
                                        color: Color(0xff555555),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: "28 Days",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Absent : ",
                                      style: TextStyle(
                                          color: Color(0xff555555),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "1",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                    text: "Half Day : ",
                                    style: TextStyle(
                                        color: Color(0xff555555),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: "2 Days",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                              RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                    text: "Unmarked Attendance : ",
                                    style: TextStyle(
                                        color: Color(0xff555555),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: "2",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showFilters() async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: reportBG,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Filter",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: colorGrayDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                  child: TextFormField(
                    style: const TextStyle(
                        color: colorGrayDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    autocorrect: true,
                    enableSuggestions: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: colorGrayLite,
                      hintText: "Name",
                      prefixText: "   ",
                      hintStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: colorGray),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    style: const TextStyle(
                        color: colorGrayDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    autocorrect: true,
                    enableSuggestions: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: colorGrayLite,
                      hintText: "Designation",
                      prefixText: "   ",
                      hintStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: colorGray),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    style: const TextStyle(
                        color: colorGrayDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    autocorrect: true,
                    enableSuggestions: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: colorGrayLite,
                      hintText: "Location",
                      prefixText: "   ",
                      hintStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: colorGray),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: 180,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
