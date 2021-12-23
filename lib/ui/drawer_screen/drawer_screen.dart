import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/drawer_menu/home_screen/home_screen.dart';
import 'package:dms/ui/drawer_menu/settings_screen/settings_screen.dart';
import 'package:dms/ui/login_screen/login_screen.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_bloc.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_events.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_states.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  KFDrawerController controller =
      KFDrawerController(initialPage: KFDrawerContent());

  StartMyDayBloc startMyDayBloc = StartMyDayBloc();

  @override
  void initState() {
    super.initState();
    controller = KFDrawerController(
      initialPage: HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: KFDrawer(
        menuPadding: const EdgeInsets.only(top: 20),
        shadowOffset: 10,
        controller: controller,
        minScale: 0.80,
        scrollable: true,
        drawerWidth: 0.80,
        disableContentTap: true,
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
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        imageUrl: Constants.image,
                        imageBuilder: (context, imageProvider) {
                          return Image(
                            image: imageProvider,
                          );
                        },
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/placeholder.png"),
                        placeholder: (context, url) =>
                            Image.asset("assets/placeholder.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 5, 10, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Constants.name,
                            style: const TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                " ${Constants.designation} ",
                                style: const TextStyle(
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
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.65,
                height: 0.5,
              ),
            ),
            ListTile(
              onTap: () {
                controller.close!.call();
              },
              title: const Text("Home",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              leading: SvgPicture.asset(
                "assets/Home.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              onTap: () {
                controller.close!.call();
              },
              title: const Text("Script",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              leading: SvgPicture.asset(
                "assets/Script.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              onTap: () {
                controller.close!.call();
              },
              title: const Text("Message",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              leading: SvgPicture.asset(
                "assets/Message.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
            BlocProvider(
              create: (context) => startMyDayBloc,
              child: BlocListener<StartMyDayBloc, StartMyDayStates>(
                listener: (context, state) {
                  if (state is EndMyDaySuccessState) {
                    Fluttertoast.showToast(msg: state.endMyDayResponse.message);
                    controller.close!.call();
                  }
                  if (state is EndMyDayFailureState) {
                    Fluttertoast.showToast(msg: state.failureMessage);
                  }
                },
                child: ListTile(
                  onTap: () {
                    startMyDayBloc.add(EndMyDayEvent());
                    // controller.close!.call();
                  },
                  title: const Text("End Day",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  leading: SvgPicture.asset(
                    "assets/End-Day.svg",
                    height: 28,
                    width: 28,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                controller.close!.call();
              },
              title: const Text("Sync",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              leading: SvgPicture.asset(
                "assets/Sync.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.65,
                height: 0.5,
              ),
            ),
            ListTile(
              onTap: () {
                controller.close!.call();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
              title: const Text("Setting",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              leading: SvgPicture.asset(
                "assets/Settings.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              onTap: () {
                // controller.close!.call();
                logoutDialog(context);
              },
              title: const Text("Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              leading: SvgPicture.asset(
                "assets/Logout.svg",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  logoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
          title: const Text("Logout",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          content: const Text("Are you sure you want to logout?",
              style: TextStyle(
                  color: Color.fromRGBO(85, 85, 85, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          actions: [
            MaterialButton(
              child: const Text("Cancel",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: const Text("Logout",
                  style: TextStyle(
                      color: Color(0xfff4511e), fontWeight: FontWeight.w600)),
              onPressed: () async {
                await SharedPreference.clearSharedPreference(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    ModalRoute.withName("/"));
              },
            ),
          ],
        );
      },
    );
  }
}
