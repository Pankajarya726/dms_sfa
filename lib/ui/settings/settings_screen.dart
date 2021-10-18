import 'package:flutter/material.dart';
import 'package:sfa/ui/about_us/about_us_screen.dart';
import 'package:sfa/ui/change_password/change_password_screen.dart';
import 'package:sfa/ui/edit_profile/edit_profile_screen.dart';
import 'package:sfa/ui/login_screen/login_screen.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  List<String> textList = [
    "Edit Profile",
    "Change Password",
    "About Us",
    "Rate App",
    "Share App",
    "Logout"
  ];

  final List<Widget> settingsNavigation = [
    const EditProfileScreen(),
    const ChangePasswordScreen(),
    const AboutUsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(242),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xfffda6ab), Color(0xfff24b55)],
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text("Settings",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      const Text("Opacity",
                          style: TextStyle(color: Colors.transparent)),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 137.8,
                      margin: const EdgeInsets.only(top: 60),
                      padding: const EdgeInsets.only(top: 60),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/rounded-bg.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: const [
                          Text("Smith Johnson",
                              style: TextStyle(
                                  color: Color(0xfff24b55),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Text("Employee designation",
                              style: TextStyle(
                                  color: Color(0xff303030),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 17,
                      left: MediaQuery.of(context).size.width * 0.39,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 5,
                            ), //BoxShadow/BoxShadow
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                              "https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__480.jpg",
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          children: List.generate(textList.length, (index) {
            return GestureDetector(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffbdbdbd))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/s${index + 1}.png", width: 24),
                      const SizedBox(width: 17),
                      Expanded(
                          child: index < 5
                              ? Text(textList[index],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                              : Text(textList[index],
                                  style: const TextStyle(
                                      color: Color(0xfff24b55),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.black, size: 15),
                    ],
                  ),
                ),
                onTap: () {
                  index <= 2
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => settingsNavigation[index]),
                        )
                      : index == 3 || index == 4
                          ? Container()
                          : logoutDialog(context);
                });
          }),
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
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    ModalRoute.withName("/"));
                SharedPrefrence.clearSharedPreference(context);
              },
            ),
          ],
        );
      },
    );
  }
}
