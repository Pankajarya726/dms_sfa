import 'dart:developer';

import 'package:dms/ui/drawer_menu/home_screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  KFDrawerController controller =
      KFDrawerController(initialPage: KFDrawerContent());
  @override
  void initState() {
    super.initState();
    controller = KFDrawerController(
      initialPage: HomeScreen(),
      items: [
        KFDrawerItem.initWithPage(
          text: const Text('Home', style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.home_outlined, color: Colors.white),
          page: HomeScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: KFDrawer(
        shadowOffset: 20,
        menuPadding: const EdgeInsets.only(top: 20),
        controller: controller,
        scrollable: true,
        drawerWidth: 0.80,
        decoration: const BoxDecoration(
          color: Colors.black87,
        ),
        header: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  log("message");
                },
                icon: const Icon(Icons.close),
                color: Colors.white,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 80,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        "https://cdnb.artstation.com/p/assets/images/images/024/538/827/original/pixel-jeff-clipa-s.gif?1582740711",
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 5, 10, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Employee Name",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                " Designation ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
