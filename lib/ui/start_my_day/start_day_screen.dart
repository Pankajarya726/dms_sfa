import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_bloc.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_events.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/custom_widget/beat_bootom_sheet.dart';
import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_bloc.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_events.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_states.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_bloc.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class StartDayScreen extends StatefulWidget {
  const StartDayScreen({Key? key}) : super(key: key);

  @override
  _StartDayScreenState createState() => _StartDayScreenState();
}

class _StartDayScreenState extends State<StartDayScreen> {
  List<String> primaryTags = [
    "Retailing",
    "Joint Working",
    "Official Meeting",
    "Dealer Meeting",
    "Leave",
    "Holiday"
  ];
  Map<String, List<String>> secondaryTags = {
    "Retailing": [
      "Vijay nagar",
      "Palasiya",
      "Regel square",
      "Bangali square",
      "malwa meel square",
      "Pardesipura"
    ],
    "Joint Working": ["Joint Working1", "Joint Working2", "Joint Working3"],
    "Official Meeting": [
      "Official Meeting1",
      "Official Meeting2",
      "Official Meeting3"
    ],
    "Dealer Meeting": ["Dealer Meeting1", "Dealer Meeting2", "Dealer Meeting3"],
    "Leave": ["seek leave", "urgent leave", "planed leave"],
    "Holiday": ["National Holiday", "Local holiday"]
  };

  String selectedPrimaryTag = "Retailing";
  String selectedSecondaryTag = "";
  bool isMeeting = false;
  File? imageFile;

  TextEditingController txtRemarkController =
      TextEditingController(text: "today working");
  TextEditingController txtBeatController = TextEditingController();
  StartMyDayBloc startMyDayBloc = StartMyDayBloc();
  AddPlanBloc addPlanBloc = AddPlanBloc();
  UserLocationBloc userLocationBloc = UserLocationBloc();
  double latitude = 0.0;
  double longitude = 0.0;
  DateTime? dateTime;
  String quoteImage = "";
  String quoteText = "";
  String currentAddress = "";
  String primarytagId = "";
  String secondaryTagId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          // splashRadius: 12,
          icon: const Icon(
            Icons.arrow_back_ios,
            color: MColor.backButton,
          ),
        ),
        title: const Text(
          startMyDay,
          style: TextStyle(
            color: MColor.backButton,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.67,
          ),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => startMyDayBloc),
          BlocProvider(create: (context) => addPlanBloc),
          BlocProvider(create: (context) => userLocationBloc),
        ],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<StartMyDayBloc, StartMyDayStates>(
                builder: (context, state) {
                  if (state is StartMyDayInitialState) {
                    startMyDayBloc.add(GetQuotesAndImagesEvent());
                  }

                  if (state is GetQuotesAndImagesState) {
                    quoteImage = state.quotesAndImagesResponse.data!.image;
                    quoteText = state.quotesAndImagesResponse.data!.text;
                    dateTime = DateTime.parse(state.currentDate);
                  }
                  if (state is StartMyDayFailureState) {
                    Fluttertoast.showToast(msg: state.failureMessage);
                  }

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          height: 90,
                          fit: BoxFit.cover,
                          imageUrl: quoteImage,
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/3x/landscape_placeholder.png",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 30,
                          right: 30,
                          bottom: 20,
                          child: SingleChildScrollView(
                            child: Text(
                              quoteText,
                              style: const TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.67,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AddPlanBloc, AddPlanStates>(
                      builder: (context, state) {
                        if (state is AddPlanInitialState) {
                          addPlanBloc.add(GetAddPlanDataEvent(
                              selectedDate: DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now())));
                        }
                        if (state is AddPlanLoadingState) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is GetAddPlanDataState) {
                          txtRemarkController = TextEditingController(
                              text: state
                                  .getAddPlanDataResponse.data!.first.remark);
                        }
                        if (state is GetAddPlanFailureState) {
                          txtRemarkController = TextEditingController(text: "");
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              primaryTag,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.67,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Tags(
                              itemCount: primaryTags.length,
                              alignment: WrapAlignment.start,
                              itemBuilder: (index) {
                                return ItemTags(
                                  singleItem: true,
                                  onPressed: (item) {
                                    selectedPrimaryTag = item.title!;
                                    setState(() {});
                                  },
                                  active:
                                      selectedPrimaryTag == primaryTags[index]
                                          ? true
                                          : false,
                                  title: primaryTags[index],
                                  textActiveColor: Colors.black,
                                  textColor: const Color(0xff555555),
                                  elevation: 0,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  index: index,
                                  border:
                                      Border.all(color: MColor.colorPrimary),
                                  activeColor: const Color(0xFFFFC9CC),
                                  color: const Color(0xffFAFAFA),
                                );
                              },
                            ),
                            selectedPrimaryTag == "Retailing" ||
                                    selectedPrimaryTag == "Joint Working"
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      secondaryTag,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.67,
                                      ),
                                    ),
                                  )
                                : Container(),
                            selectedPrimaryTag == primaryTags[0]
                                ? TextFormField(
                                    scrollPadding: const EdgeInsets.all(0),
                                    readOnly: true,
                                    controller: txtBeatController,
                                    onTap: () {
                                      selectBeat(context,
                                          secondaryTags[selectedPrimaryTag]!);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      hintText: "Select Retailing",
                                      hintStyle: const TextStyle(
                                        color: MColor.backButton,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide.none),
                                      suffixIcon: const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.black,
                                      ),
                                      // suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)
                                    ),
                                  )
                                : selectedPrimaryTag == primaryTags[1]
                                    ? Tags(
                                        itemCount:
                                            secondaryTags[selectedPrimaryTag]!
                                                .length,
                                        alignment: WrapAlignment.start,
                                        itemBuilder: (index) {
                                          return ItemTags(
                                            singleItem: true,
                                            onPressed: (item) {
                                              selectedSecondaryTag =
                                                  item.title!;
                                              setState(() {});
                                            },
                                            active: selectedSecondaryTag ==
                                                    secondaryTags[
                                                            selectedPrimaryTag]![
                                                        index]
                                                ? true
                                                : false,
                                            title: secondaryTags[
                                                selectedPrimaryTag]![index],
                                            textActiveColor: Colors.black,
                                            textColor: const Color(0xff555555),
                                            elevation: 0,
                                            textStyle:
                                                const TextStyle(fontSize: 16),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            index: index,
                                            border: Border.all(
                                                color: MColor.colorPrimary),
                                            activeColor:
                                                const Color(0xFFFFC9CC),
                                            color: const Color(0xffFAFAFA),
                                          );
                                        },
                                      )
                                    : Container(),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              remark,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.67,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              minLines: 3,
                              controller: txtRemarkController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Write your remark",
                                hintStyle: const TextStyle(
                                  color: MColor.backButton,
                                ),
                                filled: true,
                                fillColor: const Color(0xffF2F2F2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<UserLocationBloc, UserLocationStates>(
                      builder: (context, state) {
                        if (state is UserLocationInitialState) {
                          userLocationBloc.add(GetUserLocationEvent());
                        }
                        if (state is GetUserLocationState) {
                          currentAddress = state.currentAddress;
                          latitude = state.latitude;
                          longitude = state.longitude;
                        }
                        if (state is UserLocationFailureState) {
                          currentAddress = state.failureMessage;
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Image(
                              image: AssetImage("assets/location.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                currentAddress,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: MColor.backButton,
                                  letterSpacing: 0.67,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              getMeeting,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: MColor.backButton,
                                letterSpacing: 0.67,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  onTap: () {
                                    isMeeting = true;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isMeeting
                                          ? const Color.fromRGBO(
                                              255, 201, 204, 0.5)
                                          : const Color.fromRGBO(
                                              196, 196, 196, 0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isMeeting
                                            ? const Color.fromRGBO(
                                                255, 201, 204, 1)
                                            : const Color.fromRGBO(
                                                196, 196, 196, 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                            letterSpacing: 0.67,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  onTap: () {
                                    isMeeting = false;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isMeeting
                                          ? const Color.fromRGBO(
                                              196, 196, 196, 0.5)
                                          : const Color.fromRGBO(
                                              255, 201, 204, 0.5),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isMeeting
                                            ? const Color.fromRGBO(
                                                196, 196, 196, 1)
                                            : const Color.fromRGBO(
                                                255, 201, 204, 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                            letterSpacing: 0.67,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              selfie,
                              style: TextStyle(
                                letterSpacing: 0.67,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: MColor.backButton,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                selectImage();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color.fromRGBO(85, 85, 85, 1),
                                    width: 1,
                                  ),
                                ),
                                child: imageFile == null
                                    ? Center(
                                        child: Image(
                                          image: const AssetImage(
                                              "assets/camera_icon.png"),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image(
                                          image: FileImage(imageFile!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocProvider(
        create: (context) => startMyDayBloc,
        child: BlocListener<StartMyDayBloc, StartMyDayStates>(
          listener: (context, state) {
            if (state is StartMyDaySuccessState) {
              Fluttertoast.showToast(msg: state.successMessage);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DrawerScreen()));
            }
            if (state is StartMyDayFailureState) {
              Fluttertoast.showToast(msg: state.failureMessage);
            }
          },
          child: MaterialButton(
            height: 50,
            minWidth: MediaQuery.of(context).size.width,
            color: MColor.colorSecondary,
            textColor: Colors.white,
            onPressed: () async {
              if (selectedSecondaryTag.isNotEmpty) {
                if (txtRemarkController.text.isNotEmpty) {
                  if (latitude != 0.0 && longitude != 0.0) {
                    startMyDayBloc.add(StartMyDayEvent(
                      primaryTag: selectedPrimaryTag,
                      secondaryTag: selectedSecondaryTag,
                      remark: txtRemarkController.text,
                      latitude: latitude.toString(),
                      longitude: longitude.toString(),
                      getMeeting: isMeeting ? 1 : 2,
                      startDayImage: imageFile == null ? "" : imageFile!.path,
                      primaryTagId: primarytagId,
                      secondaryTagId: secondaryTagId,
                    ));
                  } else {
                    Fluttertoast.showToast(msg: "Please turn on GPS location");
                  }
                } else {
                  Fluttertoast.showToast(msg: "Please add remark");
                }
              } else {
                Fluttertoast.showToast(msg: "Please select secondary tag");
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  letsBegin,
                  style: TextStyle(
                    letterSpacing: 0.67,
                  ),
                ),
                Icon(Icons.arrow_forward_outlined)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectBeat(BuildContext context, List<String> secondaryTag) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return BeatBottomSheet(
              beat: txtBeatController.text,
              beats: secondaryTag,
              onBeatSelect: (String beat) {
                txtBeatController.text = beat;
                selectedSecondaryTag = txtBeatController.text;
              });
        });
  }

  void selectImage() async {
    XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 512,
        maxWidth: 512,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      imageFile = File(image.path);
      setState(() {});
    }
  }

  // Future<Position> getUserLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       Fluttertoast.showToast(
  //           msg: "Please turn on the location for continue!");
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.

  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.

  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // Future<void> getUserPosition() async {
  //   Position position = await getUserLocation();
  //   latitude = position.latitude;
  //   longitude = position.longitude;
  //   // List<Placemark> placemarks =
  //   //     await placemarkFromCoordinates(position.latitude, position.longitude);
  //   // Placemark place = placemarks[0];
  //   // city = place.locality!;
  //   // myState = place.administrativeArea!;
  //   // country = place.country!;
  //   // timeZone = "Time Zone in " +
  //   //     city +
  //   //     ", " +
  //   //     myState +
  //   //     ", " +
  //   //     country +
  //   //     " (GMT+5:30)";
  // }

}
