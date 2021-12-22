import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/main.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/model/primary_tag_response.dart';
import 'package:dms/model/secondary_tag_response.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_bloc.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_events.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/custom_widget/primary_tag_widget.dart';
import 'package:dms/ui/custom_widget/secondary_tag_widget.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StartDayScreen extends StatefulWidget {
  const StartDayScreen({Key? key}) : super(key: key);

  @override
  _StartDayScreenState createState() => _StartDayScreenState();
}

class _StartDayScreenState extends State<StartDayScreen> {
  bool isMeeting = false;
  File? imageFile;
  TextEditingController txtRemarkController = TextEditingController();
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
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  PlanDataModel? planDateModel;
  PrimaryTagListener? primaryTagListener;
  SecondaryTagListener? secondaryTagListener;
  PrimaryTag? primaryTag;
  SecondaryTag? secondaryTag;

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
      body: SmartRefresher(
        primary: false,
        controller: refreshController,
        onRefresh: onRefresh,
        enablePullDown: true,
        child: MultiBlocProvider(
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
                          quoteImage.isNotEmpty
                              ? Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    color: const Color(0xff000000)
                                        .withOpacity(0.4),
                                  ),
                                )
                              : Container(),
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
                            addPlanBloc.add(GetSavedPlanEvent(
                                selectedDate: DateFormat("yyyy-MM-dd")
                                    .format(DateTime.now())));
                          }
                          if (state is AddPlanLoadingState) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (state is GetSavedPlanState) {
                            planDateModel = state.planDateModel;
                            txtRemarkController.text = planDateModel!.remark;
                            primaryTag = PrimaryTag(
                                id: planDateModel!.primaryTagId,
                                name: planDateModel!.primaryTag);
                            secondaryTag = SecondaryTag(
                                id: planDateModel!.secondaryTagId,
                                name: planDateModel!.secondaryTag);
                            debugPrint(
                                "add plan data = ${state.planDateModel}");
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Primary Tag",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.67,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              PrimaryTagWidget(
                                  onSelect: (tag) {
                                    primaryTag = tag;
                                  },
                                  onInit: (PrimaryTagListener listener) {}),
                              SecondaryTagWidget(
                                  onSelect: (tag) {},
                                  onInit: (SecondaryTagListener listener) {}),
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
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                                      color:
                                          const Color.fromRGBO(85, 85, 85, 1),
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
                                          borderRadius:
                                              BorderRadius.circular(7),
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
      ),
      bottomNavigationBar: BlocProvider(
        create: (context) => startMyDayBloc,
        child: BlocListener<StartMyDayBloc, StartMyDayStates>(
          listener: (context, state) {
            if (state is StartMyDaySuccessState) {
              Fluttertoast.showToast(msg: state.successMessage);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DrawerScreen()),
                  (route) => false);
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
              // if (selectedSecondaryTag.isNotEmpty) {
              //   if (txtRemarkController.text.isNotEmpty) {
              //     if (latitude != 0.0 && longitude != 0.0) {
              //       startMyDayBloc.add(StartMyDayEvent(
              //         primaryTag: selectedPrimaryTag,
              //         secondaryTag: selectedSecondaryTag,
              //         remark: txtRemarkController.text,
              //         latitude: latitude.toString(),
              //         longitude: longitude.toString(),
              //         getMeeting: isMeeting ? 1 : 2,
              //         startDayImage: imageFile == null ? "" : imageFile!.path,
              //         primaryTagId: "1",
              //         secondaryTagId: "1",
              //         address: currentAddress,
              //       ));
              //     } else {
              //       Fluttertoast.showToast(msg: "Please turn on GPS location");
              //       userLocationBloc.add(GetUserLocationEvent());
              //     }
              //   } else {
              //     Fluttertoast.showToast(msg: "Please add remark");
              //   }
              // } else {
              //   Fluttertoast.showToast(msg: "Please select secondary tag");
              // }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  letsBegin,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.67,
                  ),
                ),
                Image(
                  width: 30,
                  image: AssetImage("assets/arrow.png"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectBeat(BuildContext context, List<String> secondaryTag) async {
    // showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    //     builder: (context) {
    //       return BeatBottomSheet(
    //           beat: txtBeatController.text,
    //           beats: secondaryTag,
    //           onBeatSelect: (String beat) {
    //             txtBeatController.text = beat;
    //             selectedSecondaryTag = txtBeatController.text;
    //           });
    //     });
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

  void onRefresh() async {
    setState(() {});
    primaryTag = null;
    secondaryTag = null;
    isMeeting = false;
    latitude = 0.0;
    longitude = 0.0;
    quoteImage = "";
    quoteText = "";
    currentAddress = "";
    imageFile = null;
    dateTime = null;
    txtRemarkController = TextEditingController();
    txtBeatController = TextEditingController();
    startMyDayBloc.add(GetQuotesAndImagesEvent());
    addPlanBloc.add(GetSavedPlanEvent(
        selectedDate: DateFormat("yyyy-MM-dd").format(DateTime.now())));
    userLocationBloc.add(GetUserLocationEvent());
    refreshController.refreshCompleted();
  }
}
