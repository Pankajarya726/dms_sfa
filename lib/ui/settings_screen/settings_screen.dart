import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/change_password/change_password_screen.dart';
import 'package:dms/ui/edit_profile/edit_profile_screen.dart';
import 'package:dms/ui/edit_profile/model/update_profile_response.dart';
import 'package:dms/ui/login_screen/login_screen.dart';
import 'package:dms/ui/settings_screen/settings_bloc/settings_bloc.dart';
import 'package:dms/ui/settings_screen/settings_bloc/settings_event.dart';
import 'package:dms/ui/settings_screen/settings_bloc/settings_state.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/in_app_review.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  SettingsBloc settingsBloc = SettingsBloc();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<String> textList = ["Edit Profile", "Change Password", "About Us", "Rate App", "Share App", "Logout"];
  User? user;

  @override
  void initState() {
    super.initState();
    addEvent();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context, true);
          }
          return Future.value(true);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocProvider<SettingsBloc>(
            create: (context) => settingsBloc,
            child: BlocListener<SettingsBloc, SettingsState>(
              listener: (context, state) {
                if (state is GetUserDetailsSuccessState) {
                  user = state.user;
                }
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SmartRefresher(
                  primary: false,
                  controller: refreshController,
                  onRefresh: onRefresh,
                  enablePullDown: true,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Container(
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
                                height: 50,
                                margin: const EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text("Settings",
                                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                                    const Text("Opacity", style: TextStyle(color: Colors.transparent)),
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 128,
                                    margin: const EdgeInsets.only(top: 60),
                                    padding: const EdgeInsets.only(top: 60),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/3x/rounded-bg.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
                                          if (user != null) {
                                            return Text(user!.name,
                                                style: const TextStyle(
                                                    color: Color(0xfff24b55), fontSize: 20, fontWeight: FontWeight.w600));
                                          }
                                          return Text(Constants.name,
                                              style: const TextStyle(
                                                  color: Color(0xfff24b55), fontSize: 20, fontWeight: FontWeight.w600));
                                        }),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(Constants.designation,
                                            style:
                                                const TextStyle(color: Color(0xff303030), fontSize: 14, fontWeight: FontWeight.w600))
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
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
                                          String url = Constants.image;
                                          if (state is GetUserDetailsSuccessState) {
                                            url = state.user.profilePicture;
                                          }
                                          return CachedNetworkImage(
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                            imageUrl: url,
                                            errorWidget: (context, url, error) => Image.asset("assets/3x/placeholder.png"),
                                            placeholder: (context, url) => const CircularProgressIndicator(
                                              color: Colors.red,
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            children: List.generate(textList.length, (index) {
                              return Container(
                                // padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1, color: Color(0xffbdbdbd))),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    onItemClick(index, context);
                                  },
                                  title: Text(textList[index],
                                      style: TextStyle(
                                          color: index == 5 ? const Color(0xfff24b55) : Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  leading: Image.asset("assets/s${index + 1}.png", width: 24),
                                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  onItemClick(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())).then((value) => addEvent());
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChangePasswordScreen(),
          ),
        );
        break;

      case 2:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         const AboutUsScreen(),
        //   ),
        // );
        Fluttertoast.showToast(msg: StringConst.comingSoon);
        break;

      case 3:
        rateApp();
        break;

      case 4:
        share();
        break;

      case 5:
        logoutDialog(context);
        break;

      default:
        Fluttertoast.showToast(msg: StringConst.comingSoon);
        break;
    }
  }

  logoutDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
          title: const Text("Logout", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
          content: const Text("Are you sure you want to logout?",
              style: TextStyle(color: Color.fromRGBO(85, 85, 85, 1), fontSize: 15, fontWeight: FontWeight.w500)),
          actions: [
            MaterialButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: const Text("Logout", style: TextStyle(color: Color(0xfff4511e), fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => const LoginScreen()), ModalRoute.withName("/"));
                SharedPreference.clearSharedPreference(context);
              },
            ),
          ],
        );
      },
    );
  }

  addEvent() async {
    var usrId = await SharedPreference.getStringPreference(SharedPreference.userId);
    settingsBloc.add(GetSettingEvent(userId: usrId));
  }

  void onRefresh() {
    addEvent();
    refreshController.refreshCompleted();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'VV SalesMitra',
        text: 'Click the below link to download the app',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.vvapps.dms',
        chooserTitle: "VV SalesMitra");
  }

  void rateApp() async {
    AppRating.openStoreListing();
  }
}
