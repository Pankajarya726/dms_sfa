import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfa/ui/attendence_home/attendence_home_screen.dart';
import 'package:sfa/ui/home_screen/home_screen_bloc/home_screen_bloc.dart';
import 'package:sfa/ui/home_screen/home_screen_bloc/home_screen_event.dart';
import 'package:sfa/ui/home_screen/home_screen_bloc/home_screen_state.dart';
import 'package:sfa/ui/settings/settings_screen.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenBloc homeScreenBloc = HomeScreenBloc();
  List<String> icons = [
    "assets/home-ic1.png",
    "assets/home-ic2.png",
    "assets/home-ic3.png",
    "assets/home-ic4.png",
    "assets/home-ic5.png",
    "assets/home-ic6.png"
  ];
  List<String> title = [
    "Attendence",
    "Mapping",
    "Enrollment",
    "Task",
    "Orders",
    "Add Visit"
  ];
  List<String> subTitle = [
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
  ];
  String imageUrl = "";
  String employeeName = "";
  String designation = "";

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenBloc>(
      create: (context) => homeScreenBloc,
      child: BlocListener<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {
          if (state is HomeScreenLoadingState) {
            const CircularProgressIndicator();
          }
          if (state is HomeScreenSuccessState) {
            imageUrl = state.userData.image;
            employeeName = state.userData.name;
            designation = state.userData.designation;
          }
          if (state is HomeScreenFailureState) {
            log(state.messages);
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              Container(
                alignment: Alignment.center,
                color: colorPrimary,
                padding: const EdgeInsets.only(top: 35),
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                    return ListTile(
                      leading: imageUrl.isNotEmpty
                          ? Container(
                              width: 58.0,
                              height: 58.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                              ),
                            )
                          : Container(
                              width: 58.0,
                              height: 58.0,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/placeholder.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      title: employeeName.isNotEmpty
                          ? Text(
                              employeeName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              "Username",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                      subtitle: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(10)),
                              child: designation.isNotEmpty
                                  ? Text(
                                      "  " + designation + "  ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )
                                  : const Text(
                                      "  Designation  ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsScreen()));
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage("assets/setting.png"),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: colorGrayLite,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    shrinkWrap: false,
                    itemCount: 6,
                    itemBuilder: (context, int index) {
                      return Card(
                        margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AttendenceHomeScreen()));
                            }
                          },
                          horizontalTitleGap: 20,
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: AssetImage(icons[index]),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Text(
                              title[index],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 16),
                            child: Text(
                              subTitle[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          trailing: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 28,
                              color: colorGrayDark,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getUserId() async {
    var userId = await SharedPrefrence.getStringPreference(SharedPrefrence.id);
    homeScreenBloc.add(HomeScreenEvent(id: userId));
  }
}
