import 'package:dms/ui/drawer_menu/home_screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kf_drawer/kf_drawer.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  KFDrawerController controller = KFDrawerController(initialPage: KFDrawerContent());
  @override
  void initState() {
    super.initState();
    controller = KFDrawerController(
      initialPage: HomeScreen(),
      items: [
        KFDrawerItem.initWithPage(
          icon: Container(
            height: 0.5,
            width: 240,
            color: Colors.white,
            child: const Icon(
              Icons.line_style,
              color: Colors.white,
              size: 1,
            ),
          ),
        ),
        //  Home
        KFDrawerItem.initWithPage(
          text: const Padding(
            padding: EdgeInsets.only(top: 18, left: 10),
            child: Text('Home', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              child: SvgPicture.asset(
                "assets/Home.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          page: HomeScreen(),
        ),
        // Script
        KFDrawerItem.initWithPage(
          text: const Padding(
            padding: EdgeInsets.only(top: 16, left: 10),
            child: Text('Script', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              child: SvgPicture.asset(
                "assets/Script.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          page: HomeScreen(),
        ),
        // message
        KFDrawerItem.initWithPage(
          text: const Padding(
            padding: EdgeInsets.only(top: 16, left: 10),
            child: Text('Message', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              child: SvgPicture.asset(
                "assets/Message.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          page: HomeScreen(),
        ),
        // Start day
        KFDrawerItem.initWithPage(
          text: const Padding(
            padding: EdgeInsets.only(top: 16, left: 10),
            child: Text('End Day', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              child: SvgPicture.asset(
                "assets/End-Day.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          page: HomeScreen(),
        ),
        // sync
        KFDrawerItem.initWithPage(
          text: const Padding(
            padding: EdgeInsets.only(top: 16, left: 10),
            child: Text('Sync', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              child: SvgPicture.asset(
                "assets/Sync.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          page: HomeScreen(),
        ), // line
        //line
        KFDrawerItem.initWithPage(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: 0.5,
              width: 240,
              color: Colors.white,
              child: const Icon(
                Icons.line_style,
                color: Colors.white,
                size: 1,
              ),
            ),
          ),
        ),
        // settings
        KFDrawerItem.initWithPage(
          text: const Padding(
            padding: EdgeInsets.only(top: 16, left: 10),
            child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              child: SvgPicture.asset(
                "assets/Settings.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          page: HomeScreen(),
        ),
        // logout
        KFDrawerItem.initWithPage(
          text: const Padding(
            padding: EdgeInsets.only(top: 16, left: 10),
            child: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              child: SvgPicture.asset(
                "assets/Logout.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          page: HomeScreen(),
        ), // line
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: KFDrawer(
        menuPadding: const EdgeInsets.only(top: 20),
        shadowOffset: 20,
        controller: controller,
        minScale: 0.80,
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
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 14),
                child: InkWell(
                  onTap: () {
                    controller.close!.call();
                  },
                  child: SvgPicture.asset(
                    "assets/Close.svg",
                    height: 28,
                    width: 28,
                    fit: BoxFit.contain,
                  ),
                ),
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
                            style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w400),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
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
