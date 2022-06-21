// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/add_store/outlet_information/outlet_information.dart';
import 'package:dms/ui/drawer_menu/home_screen/bloc/home_screen_bloc.dart';
import 'package:dms/ui/drawer_menu/home_screen/bloc/home_screen_events.dart';
import 'package:dms/ui/drawer_menu/home_screen/bloc/home_screen_states.dart';
import 'package:dms/ui/my_plan/my_plan.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_list_screen.dart';
import 'package:dms/ui/task/task/task_list_screen.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:marquee/marquee.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/get_menus_response.dart';

// ignore: must_be_immutable
class HomeScreen extends KFDrawerContent {
  final Function(ProfileUpdateListener listener) onInit;

  HomeScreen({required this.onInit});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// home screen
class _HomeScreenState extends State<HomeScreen> implements ProfileUpdateListener {
  int currentBottomTabIndex = 0;

  HomeScreenBloc homeScreenBloc = HomeScreenBloc();
  RefreshController refreshController = RefreshController(initialRefresh: false);

  List<MenuData> menu = [];

  @override
  void initState() {
    super.initState();
    widget.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeScreenBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          toolbarHeight: 75,
          elevation: 3,
          shadowColor: Colors.black26,
          centerTitle: false,
          leading: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onTap: widget.onMenuPressed,
              child: SizedBox(
                child: Align(
                  child: SvgPicture.asset(
                    "assets/menu.svg",
                    height: 30,
                    width: 30,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          title: BlocBuilder<HomeScreenBloc, HomeScreenStates>(
            bloc: homeScreenBloc,
            builder: (context, state) {
              if (state is HomeScreenlodaingState) {}
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      imageUrl: Constants.image,
                      imageBuilder: (context, imageProvider) {
                        return Image(
                          image: imageProvider,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        );
                      },
                      errorWidget: (context, url, error) => Image.asset("assets/placeholder.png"),
                      placeholder: (context, url) => Image.asset("assets/placeholder.png"),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          height: 30,
                          // width: MediaQuery.of(context).size.width * 0.55,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3505A).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Constants.designation.length > 25
                              ? Marquee(
                                  text: Constants.designation,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

                                  // scrollAxis: Axis.horizontal,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 35.0,
                                  // // velocity: 100.0,
                                  // pauseAfterRound: Duration(seconds: 1),
                                  // startPadding: 10.0,
                                  // accelerationDuration: Duration(seconds: 1),
                                  // accelerationCurve: Curves.linear,
                                  // decelerationDuration: Duration(milliseconds: 500),
                                  // decelerationCurve: Curves.easeOut,
                                )
                              : Text(
                                  Constants.designation,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: Colors.grey[600],
            currentIndex: currentBottomTabIndex,
            type: BottomNavigationBarType.fixed,
            onTap: ontemTaped,
            elevation: 0,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: SvgPicture.asset(
                    "assets/tutorials.svg",
                    height: 25,
                    width: 25,
                    fit: BoxFit.contain,
                  ),
                ),
                label: "Tutorials",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: SvgPicture.asset(
                    "assets/product.svg",
                    height: 25,
                    width: 25,
                    fit: BoxFit.contain,
                  ),
                ),
                label: "Product",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: SvgPicture.asset(
                    "assets/performance.svg",
                    height: 25,
                    width: 25,
                    fit: BoxFit.contain,
                  ),
                ),
                label: "Performance",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: SvgPicture.asset(
                    "assets/plan.svg",
                    height: 25,
                    width: 25,
                    fit: BoxFit.contain,
                  ),
                ),
                label: "Plan",
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomeScreenBloc, HomeScreenStates>(
          builder: (context, state) {
            debugPrint("state->$state");
            if (state is HomeScreenInitialState) {
              homeScreenBloc.add(GetMenusEvent());
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // if (state is HomeScreenlodaingState) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            if (state is GetMenusState) {
              menu = state.menu;
              homeScreenBloc.add(GetUserDetailsEvent());
              refreshController.refreshCompleted();
            }

            if (state is HomeScreenFailureState) {
              refreshController.refreshCompleted();
              // return Center(
              //   child: MaterialButton(
              //     onPressed: () {
              //       homeScreenBloc.add(GetMenusEvent());
              //     },
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //     color: MColor.colorPrimary,
              //     child: const Text(
              //       "Refresh",
              //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.5, fontSize: 16),
              //     ),
              //   ),
              // );
              // return NoInternetConnection(
              //   onRefresh: () {
              //     homeScreenBloc.add(GetMenusEvent());
              //   },
              // );
            }
            return SmartRefresher(
              // primary: false,
              controller: refreshController,
              onRefresh: onRefresh,
              enablePullDown: true,
              header: const MaterialClassicHeader(),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                children: List.generate(menu.length, (index) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 8,
                          color: Color.fromRGBO(181, 181, 181, 0.25),
                        )
                      ],
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onTap: () {
                          navigateToHomeItems(menu[index].id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: menu[index].menuImage,
                                imageBuilder: (context, imageProvider) {
                                  return Image(
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width / 8,
                                      height: MediaQuery.of(context).size.width / 8,
                                      image: imageProvider);
                                },
                                errorWidget: (context, url, error) {
                                  return Container();
                                },
                              ),
                              Text(
                                menu[index].menuName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  letterSpacing: 0.67,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  void navigateToHomeItems(index) {
    switch (index) {
      case 1:
        Utility.showToast(StringConst.comingSoon);
        break;
      case 2:
        Utility.showToast(StringConst.comingSoon);
        break;
      case 3:
        // Fluttertoast.showToast(msg: StringConst.comingSoon);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskListScreen()));
        break;
      case 4:
        // Utility.showToast( StringConst.comingSoon);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OutletInformation()));
        break;
      case 5:
        // Fluttertoast.showToast(msg: StringConst.comingSoon);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RetailerListScreen()));
        break;
      case 6:
        Utility.showToast(StringConst.comingSoon);
        break;
    }
  }

  void navigateToBottomBarItems() {
    switch (currentBottomTabIndex) {
      case 0:
        Utility.showToast(StringConst.comingSoon);
        break;
      case 1:
        Utility.showToast(StringConst.comingSoon);
        break;
      case 2:
        Utility.showToast(StringConst.comingSoon);
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyPlan()));
        break;
    }
  }

  void ontemTaped(int index) {
    currentBottomTabIndex = index;
    // setState(() {
    //   currentBottomTabIndex = index;
    // });
    navigateToBottomBarItems();
  }

  void onRefresh() async {
    homeScreenBloc.add(GetMenusEvent());
  }

  @override
  void onProfileUpdate() {
    homeScreenBloc.add(GetUserDetailsEvent());
  }
}

abstract class ProfileUpdateListener {
  void onProfileUpdate();
}
