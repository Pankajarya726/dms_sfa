import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dms/main.dart';
import 'package:dms/model/get_all_tag_response.dart';
import 'package:dms/model/get_plan_response.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_bloc.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_events.dart';
import 'package:dms/ui/add_plan/bloc/add_plan_states.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/ui/custom_widget/beat_bottom_sheet.dart';
import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_bloc.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_events.dart';
import 'package:dms/ui/start_my_day/bloc/start_my_day_states.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_bloc.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StartDayScreen extends StatefulWidget {
  const StartDayScreen({Key? key}) : super(key: key);

  @override
  _StartDayScreenState createState() => _StartDayScreenState();
}

class _StartDayScreenState extends State<StartDayScreen> {
  bool isMeeting = false;
  File? imageFile;
  String fileName = "test.jpg";
  TextEditingController txtRemarkController = TextEditingController();
  TextEditingController txtBeatController = TextEditingController();
  StartMyDayBloc startMyDayBloc = StartMyDayBloc();
  AddPlanBloc addPlanBloc = AddPlanBloc();
  UserLocationBloc userLocationBloc = UserLocationBloc();
  CommonBloc commonBloc = CommonBloc();
  double latitude = 0.0;
  double longitude = 0.0;
  DateTime? dateTime;
  String quoteImage = "";
  String quoteText = "";
  String currentAddress = "";
  RefreshController refreshController = RefreshController(initialRefresh: false);

  PlanDataModel? planDateModel;

  List<PrimaryTag> primaryTagList = [];
  List<SecondaryTag> selectedSecondaryTags = [];

  PrimaryTag? selectedPrimaryTag;

  GlobalKey globalKey = GlobalKey();

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
            BlocProvider(create: (context) => commonBloc),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<StartMyDayBloc, StartMyDayStates>(listener: (context, state) {
                if (state is GetQuotesAndImagesState) {
                  quoteImage = state.quotesAndImagesResponse.data!.image;
                  quoteText = state.quotesAndImagesResponse.data!.text;
                  dateTime = DateTime.parse(state.currentDate);
                }
                if (state is StartMyDayFailureState) {
                  Fluttertoast.showToast(msg: state.failureMessage);
                }
              }),
              BlocListener<AddPlanBloc, AddPlanStates>(listener: (context, state) {
                if (state is GetSavedPlanState) {
                  refreshController.refreshCompleted();
                  planDateModel = state.planDateModel;
                  txtRemarkController.text = state.planDateModel.remark;
                  // selectedSecondaryTags = state.planDateModel.secondaryTags;
                  // String selectedBeats = state.planDateModel.secondaryTag;
                  // if (selectedSecondaryTags.isNotEmpty) {
                  //   for (int i = 0; i < selectedSecondaryTags.length; i++) {
                  //     if (i == selectedSecondaryTags.length - 1) {
                  //       selectedBeats += selectedSecondaryTags[i].name;
                  //     } else {
                  //       selectedBeats += selectedSecondaryTags[i].name + ", ";
                  //     }
                  //   }
                  // }
                  //
                  // txtBeatController.text = selectedBeats;

                  List<SecondaryTag> secTag =
                      primaryTagList.singleWhere((element) => element.id == int.parse(state.planDateModel.primaryTagId)).secondaryTag;

                  for (var element in secTag) {
                    element.check = false;
                  }

                  if (state.planDateModel.secondaryTags.isNotEmpty) {
                    for (var element in state.planDateModel.secondaryTags) {
                      secTag.singleWhere((tag) => tag.id == element.id).check = true;
                    }
                  }

                  selectedPrimaryTag = PrimaryTag(
                      id: int.parse(state.planDateModel.primaryTagId),
                      name: state.planDateModel.primaryTag,
                      selectionType: primaryTagList
                          .singleWhere((element) => element.id.toString() == state.planDateModel.primaryTagId)
                          .selectionType,
                      selected: 1,
                      canSelect: 1,
                      secondaryTagType: primaryTagList
                          .singleWhere((element) => element.id.toString() == state.planDateModel.primaryTagId)
                          .secondaryTagType,
                      secondaryTag: secTag);

                  addPlanBloc.add(SelectPrimaryEvent(primaryTag: selectedPrimaryTag!));
                  addPlanBloc.add(SelectSecondaryEvent(secondaryTag: secTag.where((element) => element.check).toList()));
                }

                if (state is GetAddPlanFailureState) {
                  refreshController.refreshCompleted();
                  selectedSecondaryTags.clear();
                  txtRemarkController.clear();
                  txtBeatController.clear();
                  planDateModel = null;

                  try {
                    selectedPrimaryTag = primaryTagList.firstWhere(
                      (element) => element.selected == 1,
                    );
                    for (var element in selectedPrimaryTag!.secondaryTag) {
                      element.check = false;
                    }
                    addPlanBloc.add(SelectPrimaryEvent(primaryTag: selectedPrimaryTag!));
                  } catch (exception) {
                    debugPrint("exception--->$exception");
                  }
                }

                if (state is GetTagState) {
                  primaryTagList = state.primaryTagList;

                  try {
                    selectedPrimaryTag = primaryTagList.firstWhere(
                      (element) => element.selected == 1,
                    );
                  } catch (exception) {
                    debugPrint("exception--->$exception");
                  }

                  getCurrentDate();
                }
              }),
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
                                      height: MediaQuery.of(context).size.width * 0.5,
                                      color: const Color(0xff000000).withOpacity(0.4),
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
                        Column(
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
                            BlocBuilder<AddPlanBloc, AddPlanStates>(
                              builder: (context, state) {
                                if (state is AddPlanInitialState) {
                                  addPlanBloc.add(GetTagEvent());
                                }

                                if (primaryTagList.isEmpty) {
                                  return Container();
                                }
                                if (state is SelectPrimaryTagState) {
                                  selectedPrimaryTag = state.primaryTag;
                                  selectedSecondaryTags.clear();
                                  txtBeatController.clear();

                                  // selectedSecondaryTags = state.primaryTag.secondaryTag.where((element) => element.check).toList();
                                  // if (selectedSecondaryTags.isNotEmpty) {
                                  //   String selectedBeats = "";
                                  //   for (int i = 0; i < selectedSecondaryTags.length; i++) {
                                  //     if (i == selectedSecondaryTags.length - 1) {
                                  //       selectedBeats += selectedSecondaryTags[i].name;
                                  //     } else {
                                  //       selectedBeats += selectedSecondaryTags[i].name + ", ";
                                  //     }
                                  //   }
                                  //   txtBeatController.text = selectedBeats;
                                  // }
                                }

                                return Tags(
                                  itemCount: primaryTagList.length,
                                  alignment: WrapAlignment.start,
                                  itemBuilder: (index) {
                                    return ItemTags(
                                      customData: primaryTagList[index],
                                      singleItem: true,
                                      onPressed: (item) {
                                        addPlanBloc.add(SelectPrimaryEvent(primaryTag: item.customData));
                                      },
                                      pressEnabled: primaryTagList[index].canSelect == 1,
                                      active: selectedPrimaryTag == null ? false : selectedPrimaryTag!.id == primaryTagList[index].id,
                                      title: primaryTagList[index].name,
                                      textActiveColor: Colors.black,
                                      textColor: const Color(0xff555555),
                                      elevation: 0,
                                      textStyle: const TextStyle(fontSize: 16),
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      index: index,
                                      border: Border.all(
                                          color: selectedPrimaryTag == null
                                              ? const Color.fromRGBO(197, 197, 197, 1)
                                              : selectedPrimaryTag!.id == primaryTagList[index].id
                                                  ? MColor.colorPrimary
                                                  : const Color.fromRGBO(197, 197, 197, 1)),
                                      activeColor: selectedPrimaryTag == null
                                          ? const Color(0xffFAFAFA)
                                          : selectedPrimaryTag!.id == primaryTagList[index].id
                                              ? const Color(0xFFFFC9CC)
                                              : const Color(0xffFAFAFA),
                                      color: selectedPrimaryTag == null
                                          ? const Color(0xffFAFAFA)
                                          : selectedPrimaryTag!.id == primaryTagList[index].id
                                              ? const Color(0xFFFFC9CC)
                                              : const Color(0xffFAFAFA),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            BlocBuilder<AddPlanBloc, AddPlanStates>(
                              builder: (context, state) {
                                if (state is AddPlanInitialState) {
                                  return Container();
                                }
                                if (selectedPrimaryTag == null) {
                                  return Container();
                                }

                                if (state is SelectSecondaryState) {
                                  selectedSecondaryTags = state.secondaryTag;
                                  debugPrint("selectedSecondaryTags--->$selectedSecondaryTags");
                                  String selectedBeats = "";
                                  if (selectedSecondaryTags.isNotEmpty) {
                                    for (int i = 0; i < selectedSecondaryTags.length; i++) {
                                      if (i == selectedSecondaryTags.length - 1) {
                                        selectedBeats += selectedSecondaryTags[i].name;
                                      } else {
                                        selectedBeats += selectedSecondaryTags[i].name + ", ";
                                      }
                                    }
                                  }
                                  txtBeatController.text = selectedBeats;
                                }

                                if (selectedPrimaryTag!.secondaryTag.isEmpty) {
                                  return Container();
                                }

                                debugPrint(selectedPrimaryTag!.secondaryTag.toString());
                                debugPrint(selectedPrimaryTag!.secondaryTagType.toString());

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      child: Text(
                                        "Secondary Tag",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.67,
                                        ),
                                      ),
                                    ),
                                    selectedPrimaryTag!.secondaryTagType == "drop_down"
                                        ? TextFormField(
                                            scrollPadding: const EdgeInsets.all(0),
                                            readOnly: true,
                                            controller: txtBeatController,
                                            onTap: () {
                                              selectBeat(context, selectedPrimaryTag!.secondaryTag);
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(15),
                                              hintText: "Select Retailing",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                              suffixIcon: const Icon(
                                                Icons.keyboard_arrow_down_outlined,
                                                color: Colors.black,
                                              ),
                                              // suffixIconConstraints: BoxConstraints(maxWidth: 20, maxHeight: 20)
                                            ),
                                          )
                                        : selectedPrimaryTag!.secondaryTagType == "tags"
                                            ? Tags(
                                                itemCount: selectedPrimaryTag!.secondaryTag.length,
                                                alignment: WrapAlignment.start,
                                                itemBuilder: (index) {
                                                  return ItemTags(
                                                    singleItem: true,
                                                    customData: selectedPrimaryTag!.secondaryTag[index],
                                                    onPressed: (item) {
                                                      addPlanBloc.add(SelectSecondaryEvent(secondaryTag: [item.customData]));
                                                    },
                                                    active: selectedSecondaryTags.isNotEmpty
                                                        ? selectedSecondaryTags.first.id == selectedPrimaryTag!.secondaryTag[index].id
                                                        : false,
                                                    title: selectedPrimaryTag!.secondaryTag[index].name,
                                                    textActiveColor: Colors.black,
                                                    textColor: const Color(0xff555555),
                                                    elevation: 0,
                                                    textStyle: const TextStyle(fontSize: 16),
                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                    index: index,
                                                    border: Border.all(
                                                        color: selectedSecondaryTags.isNotEmpty
                                                            ? selectedSecondaryTags.first.id ==
                                                                    selectedPrimaryTag!.secondaryTag[index].id
                                                                ? MColor.colorPrimary
                                                                : const Color.fromRGBO(197, 197, 197, 1)
                                                            : const Color.fromRGBO(197, 197, 197, 1)),
                                                    activeColor: const Color(0xFFFFC9CC),
                                                    color: selectedSecondaryTags.isNotEmpty
                                                        ? selectedSecondaryTags.first.id == selectedPrimaryTag!.secondaryTag[index].id
                                                            ? const Color(0xFFFFC9CC)
                                                            : const Color(0xffFAFAFA)
                                                        : const Color(0xffFAFAFA),
                                                  );
                                                },
                                              )
                                            : Container(),
                                  ],
                                );
                              },
                            ),
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
                              maxLengthEnforcement: MaxLengthEnforcement.none,
                              decoration: InputDecoration(
                                hintText: "Write your remark",
                                hintStyle: const TextStyle(
                                  color: MColor.backButton,
                                ),
                                filled: true,
                                fillColor: const Color(0xffF2F2F2),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                              ),
                              onTap: () async {
                                await Future.delayed(const Duration(milliseconds: 500));
                                RenderObject? object = globalKey.currentContext!.findRenderObject();
                                object!.showOnScreen();
                                // globalKey2 = globalKey;
                              },
                            ),
                            SizedBox(
                              key: globalKey,
                              height: 15,
                            ),
                          ],
                        ),
                        BlocBuilder<AddPlanBloc, AddPlanStates>(
                          builder: (context, snap) {
                            debugPrint("state--->$snap");

                            if (snap is SelectPrimaryTagState) {
                              selectedPrimaryTag = snap.primaryTag;
                              if (snap.primaryTag.name.trim().toLowerCase() == "holiday" ||
                                  snap.primaryTag.name.trim().toLowerCase() == "leave") {
                                return Container();
                              }
                            }

                            if (selectedPrimaryTag == null) {
                              debugPrint("selectedPrimaryTag==null");
                              return Container();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<UserLocationBloc, UserLocationStates>(
                                  builder: (context, state) {
                                    if (state is UserLocationInitialState) {
                                      userLocationBloc.add(GetUserLocationEvent());
                                    }

                                    if (state is UserLocationLoadingState) {
                                      // EasyLoading.show();
                                    }

                                    if (state is GetUserLocationState) {
                                      // EasyLoading.dismiss();
                                      currentAddress = state.currentAddress;
                                      latitude = state.latitude;
                                      longitude = state.longitude;
                                    }
                                    if (state is UserLocationFailureState) {
                                      // EasyLoading.dismiss();

                                      currentAddress = state.failureMessage;
                                    }

                                    return InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onTap: () {
                                        userLocationBloc.add(GetUserLocationEvent());
                                      },
                                      child: Row(
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
                                      ),
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
                                        BlocBuilder<CommonBloc, CommonBlocStates>(
                                          builder: (context, state) {
                                            if (state is CommonBlocGetMeetingState) {
                                              isMeeting = state.getMeeting;
                                            }

                                            return Row(
                                              children: [
                                                InkWell(
                                                  customBorder: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  onTap: () {
                                                    commonBloc.add(CommonBlocGetMeetingEvent(getMeeting: true));
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: isMeeting
                                                          ? MColor.colorSecondary.withOpacity(0.5)
                                                          : const Color.fromRGBO(196, 196, 196, 0.5),
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color: isMeeting
                                                            ? MColor.colorSecondary.withOpacity(1)
                                                            : const Color.fromRGBO(196, 196, 196, 1),
                                                        borderRadius: BorderRadius.circular(30),
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
                                                    commonBloc.add(CommonBlocGetMeetingEvent(getMeeting: false));
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: isMeeting
                                                          ? const Color.fromRGBO(196, 196, 196, 0.5)
                                                          : const Color.fromRGBO(255, 201, 204, 0.5),
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color: isMeeting
                                                            ? const Color.fromRGBO(196, 196, 196, 1)
                                                            : const Color.fromRGBO(255, 201, 204, 1),
                                                        borderRadius: BorderRadius.circular(30),
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
                                            );
                                          },
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
                                        BlocBuilder<CommonBloc, CommonBlocStates>(
                                          builder: (context, state) {
                                            if (state is CommonBlocSelectImageState) {
                                              imageFile = state.imageFile;
                                            }

                                            return InkWell(
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
                                                          image: const AssetImage("assets/camera_icon.png"),
                                                          width: MediaQuery.of(context).size.width / 7,
                                                          height: MediaQuery.of(context).size.width / 7,
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
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => startMyDayBloc),
          BlocProvider(create: (context) => addPlanBloc),
        ],
        child: BlocListener<StartMyDayBloc, StartMyDayStates>(
          listener: (context, state) {
            if (state is StartMyDaySuccessState) {
              Fluttertoast.showToast(msg: state.successMessage);
              SharedPreference.setStringPreference(SharedPreference.startMyDay, "hide");
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DrawerScreen()), (route) => false);
            }
          },
          child: BlocBuilder<AddPlanBloc, AddPlanStates>(
            builder: (context, state) {
              if (selectedPrimaryTag == null) {
                return const SizedBox();
              }
              return MaterialButton(
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                color: MColor.colorSecondary,
                textColor: Colors.white,
                onPressed: () async {
                  //when leave and holiday selected then if will execute
                  if (selectedPrimaryTag!.name.trim().toLowerCase() == "leave" ||
                      selectedPrimaryTag!.name.trim().toLowerCase() == "holiday") {
                    if (txtRemarkController.text.trim().isEmpty) {
                      Fluttertoast.showToast(msg: "Please enter remark");
                      return;
                    }
                    if (txtRemarkController.text.trim().length > 255) {
                      Fluttertoast.showToast(msg: "Word limit-250 characters");
                      return;
                    }
                    debugPrint("remark fields ok ");
                    Map<String, dynamic> input = HashMap<String, dynamic>();

                    DateTime _ntpTime = await NTP.now();
                    input["user_id"] = await SharedPreference.getStringPreference(SharedPreference.userId);
                    input["start_day_date"] = DateFormat("yyyy-MM-dd").format(_ntpTime);
                    input["start_day_time"] = "${_ntpTime.hour}:${_ntpTime.minute}:${_ntpTime.second}";
                    input["primary_tag"] = selectedPrimaryTag!.name;
                    input["primary_tag_id"] = selectedPrimaryTag!.id;
                    input["remark"] = txtRemarkController.text.trim();

                    debugPrint("start_my_day_input-->");
                    startMyDayBloc.add(StartMyDayEvent(input: input));
                  }

                  //otherwise else will execute
                  else {
                    if (selectedPrimaryTag == null) {
                      Fluttertoast.showToast(msg: "Please select primary tag");
                      return;
                    }
                    if (selectedPrimaryTag!.secondaryTag.isNotEmpty && selectedSecondaryTags.isEmpty) {
                      Fluttertoast.showToast(msg: "Please select secondary tag");
                      return;
                    }
                    // if (txtRemarkController.text.trim().isEmpty) {
                    //   Fluttertoast.showToast(msg: "Please enter remark");
                    //   return;
                    // }
                    if (txtRemarkController.text.trim().length > 255) {
                      Fluttertoast.showToast(msg: "Word limit-250 characters");
                      return;
                    }
                    if (latitude == 0.0 && longitude == 0.0) {
                      Fluttertoast.showToast(msg: "Could not fetch your location, Please try again later");
                      userLocationBloc.add(GetUserLocationEvent());
                      return;
                    }
                    if (currentAddress.isEmpty) {
                      Fluttertoast.showToast(
                          msg:
                              "Could not proceed, because we are not able to fetch your area detail. Please allow location permission to continue");
                      userLocationBloc.add(GetUserLocationEvent());
                      return;
                    }
                    debugPrint("all fields ok ");
                    Map<String, dynamic> input = HashMap<String, dynamic>();

                    DateTime _ntpTime = await NTP.now();
                    input["user_id"] = await SharedPreference.getStringPreference(SharedPreference.userId);
                    input["start_day_date"] = DateFormat("yyyy-MM-dd").format(_ntpTime);
                    input["primary_tag"] = selectedPrimaryTag!.name;
                    input["primary_tag_id"] = selectedPrimaryTag!.id;
                    if (selectedSecondaryTags.isNotEmpty) {
                      String selectedBeats = "";
                      String selectedBeatsId = "";
                      for (int i = 0; i < selectedSecondaryTags.length; i++) {
                        if (i == selectedSecondaryTags.length - 1) {
                          selectedBeats += selectedSecondaryTags[i].name;
                          selectedBeatsId += selectedSecondaryTags[i].id.toString();
                        } else {
                          selectedBeats += selectedSecondaryTags[i].name + ", ";
                          selectedBeatsId += selectedSecondaryTags[i].id.toString() + ", ";
                        }
                      }

                      input["secondary_tag"] = selectedBeats;
                      input["secondary_tag_id"] = selectedBeatsId;
                    }

                    input["remark"] = txtRemarkController.text.trim();
                    input["latitude"] = latitude.toString();
                    input["longitude"] = longitude.toString();
                    input["get_meeting"] = isMeeting ? "Yes" : "No";
                    input["start_day_address"] = currentAddress;
                    input["start_day_time"] = "${_ntpTime.hour}:${_ntpTime.minute}:${_ntpTime.second}";

                    if (imageFile != null) {
                      input["start_day_image"] = await MultipartFile.fromFile(
                        imageFile!.path,
                        filename: fileName,
                      );
                    }
                    debugPrint("start_my_day_input-->");
                    startMyDayBloc.add(StartMyDayEvent(input: input));
                  } //end of else
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectedPrimaryTag!.id == 5 || selectedPrimaryTag!.id == 6
                        ? const Text(
                            confirm,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.67,
                            ),
                          )
                        : const Text(
                            letsBegin,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.67,
                            ),
                          ),
                    const Image(
                      width: 30,
                      image: AssetImage("assets/arrow.png"),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void selectBeat(BuildContext context, List<SecondaryTag> tags) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return BeatBottomSheet(
              selectedBeat: selectedSecondaryTags,
              beats: tags,
              onBeatSelect: (List<SecondaryTag> beat) {
                String selectedBeats = "";
                if (beat.isNotEmpty) {
                  for (int i = 0; i < beat.length; i++) {
                    beat[i].name = beat[i].name;
                    if (i == beat.length - 1) {
                      selectedBeats += beat[i].name;
                    } else {
                      selectedBeats += beat[i].name + ", ";
                    }
                  }
                }
                txtBeatController.text = selectedBeats;
                addPlanBloc.add(SelectSecondaryEvent(secondaryTag: beat));
              });
        });
  }

  void selectImage() async {
    try {
      XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera,
        // maxHeight: 512,
        // maxWidth: 512,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        imageFile = File(image.path);
        fileName = image.name;
        commonBloc.add(CommonBlocSelectImageEvent(imageFile: imageFile!));
      }
    } catch (exception) {
      debugPrint("exception in image picker---->$exception");
    }
  }

  void onRefresh() async {
    imageFile = null;
    commonBloc.add(CommonBlocGetMeetingEvent(getMeeting: false));
    startMyDayBloc.add(GetQuotesAndImagesEvent());
    addPlanBloc.add(GetSavedPlanEvent(selectedDate: DateFormat("yyyy-MM-dd").format(DateTime.now())));
    userLocationBloc.add(GetUserLocationEvent());
    refreshController.refreshCompleted();
  }

  void getCurrentDate() async {
    addPlanBloc.add(GetSavedPlanEvent(selectedDate: DateFormat("yyyy-MM-dd").format(await NTP.now())));
  }
}
