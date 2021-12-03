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
  KFDrawerController? controller =
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
        controller: controller,
        scrollable: true,
        disableContentTap: true,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 256, 255, 1.0),
              Color.fromRGBO(44, 75, 171, 1.0)
            ],
            tileMode: TileMode.repeated,
          ),
        ),
        header: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                color: Colors.white,
                icon: const Icon(Icons.close),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width * 0.6,
                height: 80,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        "https://cdnb.artstation.com/p/assets/images/images/024/538/827/original/pixel-jeff-clipa-s.gif?1582740711",
                        fit: BoxFit.cover,
                        width: 65,
                        height: 65,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            " Name",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          Text(
                            " Designation",
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
