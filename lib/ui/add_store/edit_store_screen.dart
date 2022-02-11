// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'package:dms/ui/bottom_sheet_widget/select_beat_name_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_city_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_distributor_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_language_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_retailercategory_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_retailertype_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_callTimeSlot_bottom_sheet.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_bloc.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../main.dart';
import 'bloc/edit_store_bloc.dart';
import 'bloc/edit_store_events.dart';
import 'bloc/edit_store_states.dart';
import 'model/editstore_getenroll_type_response.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({Key? key}) : super(key: key);

  @override
  _EditStoreScreenState createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  Object selectEnrollmentRadio = "";
  Object existingRetailerRadio = "";
  Object whatsAppSmsRadio = "";
  Object isKRORadio = "";
  File? outletPhotoFile;
  File? ownerPhotoFile;
  String? outletFileName;
  String? ownerFileName;
  DateTime? dateTime;
  CommonBloc commonBloc = CommonBloc();
  UserLocationBloc userLocationBloc = UserLocationBloc();
  EditStoreBloc editStoreBloc = EditStoreBloc();
  TextEditingController txtOrderBookingController = TextEditingController();
  TextEditingController txtOutletNameController = TextEditingController();
  TextEditingController txtOwnerNameController = TextEditingController();
  TextEditingController txtLatitudeController = TextEditingController();
  TextEditingController txtLongtitudeController = TextEditingController();
  TextEditingController txtAddressController = TextEditingController();
  TextEditingController txtLandmarkController = TextEditingController();
  TextEditingController txtPincodeController = TextEditingController();
  TextEditingController txtPrimaryMobController = TextEditingController();
  TextEditingController txtSecondaryMobController = TextEditingController();
  TextEditingController txtGSTController = TextEditingController();
  TextEditingController txtPANController = TextEditingController();
  TextEditingController txtAdharNumberController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPicDateController = TextEditingController();
  TextEditingController txtSelectCityController = TextEditingController();
  TextEditingController txtSelectDistributorController =
      TextEditingController();
  TextEditingController txtSelectBeatNameController = TextEditingController();
  TextEditingController txtSelectCallTimeSlotController =
      TextEditingController();
  TextEditingController txtSelectLangFirstController = TextEditingController();
  TextEditingController txtSelectLangSecondController = TextEditingController();
  TextEditingController txtSelectRetailerTypeController =
      TextEditingController();
  TextEditingController txtSelectRetailerCategoryController =
      TextEditingController();
  List<EnrolmentTypeModel>? enrolmentTypeModel = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int? enrollmentTypeId;
  int? cityId;
  int? distributorId;
  int? beatId;
  int? orderBookingDayId;
  int? callTimeSlotId;
  int? primaryLangId;
  String? primaryLangCode;
  int? secondaryLangId;
  String? secondaryLangCode;
  int? retailerTypeId;
  int? retailerCategoryId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => commonBloc),
        BlocProvider(create: (context) => userLocationBloc),
        BlocProvider(create: (context) => editStoreBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.white24,
          title: const Text(
            editStore,
            style: TextStyle(
              color: MColor.backButton,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: MColor.backButton,
            ),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 10),
              onPressed: () {
                userLocationBloc.add(GetUserLocationEvent());
              },
              icon: const Image(
                width: 30,
                image: AssetImage("assets/get_location.png"),
              ),
            ),
          ],
        ),
        body: SmartRefresher(
          primary: false,
          controller: refreshController,
          onRefresh: onRefresh,
          enablePullDown: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(enrollmentType),
                  sizedBoxWidget(5.0),
                  BlocBuilder<EditStoreBloc, EditStoreStates>(
                      builder: (context, state) {
                    if (state is EditStoreInitialState) {
                      editStoreBloc.add(GetEnrolmentTypeEvent());
                    }
                    if (state is EditStoreILoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is GetEnrolmentTypeState) {
                      enrolmentTypeModel = state.getEnrollTypeResponse.data;
                    }

                    if (state is EditStoreFailureState) {
                      Fluttertoast.showToast(msg: state.failureMessage);
                    }

                    if (enrolmentTypeModel == null) {
                      return Container();
                    }
                    return BlocBuilder<CommonBloc, CommonBlocStates>(
                      builder: (context, state) {
                        if (state is CommonBlocEnrollRadioTagState) {
                          selectEnrollmentRadio = state.enrollmentRadioTag;
                          debugPrint("$selectEnrollmentRadio");
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: radioButtonWidgetList(),
                          ),
                        );
                      },
                    );
                  }),
                  sizedBoxWidget(5.0),
                  textWidget(city),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectCityController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(distributor),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectDistributorController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(beatNameMandatory),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectBeatNameController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(orderBookingDay),
                  sizedBoxWidget(12.0),
                  textFields(txtOrderBookingController, day),
                  sizedBoxWidget(20.0),
                  textWidget(outletName),
                  sizedBoxWidget(12.0),
                  textFields(txtOutletNameController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(ownerName),
                  sizedBoxWidget(12.0),
                  textFields(txtOwnerNameController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(latitude),
                  sizedBoxWidget(12.0),
                  BlocBuilder<UserLocationBloc, UserLocationStates>(
                    bloc: userLocationBloc,
                    builder: (context, state) {
                      debugPrint("state---->$state");

                      if (state is UserLocationInitialState) {
                        userLocationBloc.add(GetUserLocationEvent());
                      }

                      if (state is GetUserLocationState) {
                        if (txtLatitudeController.text !=
                                state.latitude.toString() &&
                            txtLongtitudeController.text !=
                                state.longitude.toString()) {
                          txtLatitudeController.text =
                              state.latitude.toString();
                          txtLongtitudeController.text =
                              state.longitude.toString();
                          txtAddressController.text = state.currentAddress;
                          txtPincodeController.text = state.pincode;
                        }
                      }

                      if (state is UserLocationFailureState) {
                        Fluttertoast.showToast(
                            msg: "Please turn on GPS to get current location");
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textFields(txtLatitudeController, enterHere),
                          sizedBoxWidget(17.0),
                          textWidget(longitude),
                          sizedBoxWidget(12.0),
                          textFields(txtLongtitudeController, enterHere),
                          sizedBoxWidget(17.0),
                          textWidget(address),
                          sizedBoxWidget(12.0),
                          textFields(txtAddressController, enterHere),
                          sizedBoxWidget(17.0),
                          textWidget(landmark),
                          sizedBoxWidget(12.0),
                          textFields(txtLandmarkController, enterHere),
                          sizedBoxWidget(17.0),
                          textWidget(pincode),
                          sizedBoxWidget(12.0),
                          textFields(txtPincodeController, enterHere),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(20.0),
                  textWidget(primaryMobile),
                  sizedBoxWidget(12.0),
                  textFields(txtPrimaryMobController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(secondaryMobile),
                  sizedBoxWidget(12.0),
                  textFields(txtSecondaryMobController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(existingRetailer),
                  sizedBoxWidget(5.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocRetailerRadioState) {
                        existingRetailerRadio = state.retailerRadioTag;
                        debugPrint("$existingRetailerRadio");
                      }
                      return Row(
                        children: [
                          radioButtonWidget(existingRetailerRadio, 1, yes),
                          radioButtonWidget(existingRetailerRadio, 2, no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0),
                  textWidget(callTimeSlotMand),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectCallTimeSlotController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(languageFirst),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectLangFirstController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(languageSecond),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectLangSecondController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(retailerTypeMand),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectRetailerTypeController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(retailerCategoryMand),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectRetailerCategoryController, selectHint),
                  sizedBoxWidget(20.0),
                  textWidget(whatsAppSms),
                  sizedBoxWidget(5.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocWhatsAppRadioState) {
                        whatsAppSmsRadio = state.whatsAppRadioTag;
                        debugPrint("$whatsAppSmsRadio");
                      }
                      return Row(
                        children: [
                          radioButtonWidget(whatsAppSmsRadio, 3, yes),
                          radioButtonWidget(whatsAppSmsRadio, 4, no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0),
                  textWidget(isKRO),
                  sizedBoxWidget(5.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocIsKRORadioState) {
                        isKRORadio = state.isKRORadioTag;
                        debugPrint("$isKRORadio");
                      }
                      return Row(
                        children: [
                          radioButtonWidget(isKRORadio, 5, yes),
                          radioButtonWidget(isKRORadio, 6, no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0),
                  textWidget(gstNo),
                  sizedBoxWidget(12.0),
                  textFields(txtGSTController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(pan),
                  sizedBoxWidget(12.0),
                  textFields(txtPANController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(adharNumber),
                  sizedBoxWidget(12.0),
                  textFields(txtAdharNumberController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(email),
                  sizedBoxWidget(12.0),
                  textFields(txtEmailController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(birthday),
                  sizedBoxWidget(12.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocSelectDateState) {
                        txtPicDateController.text =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                      }
                      return textFields(txtPicDateController, picDate);
                    },
                  ),
                  sizedBoxWidget(5.0),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBoxWidget(17.0),
                          textWidget(outletPhoto),
                          sizedBoxWidget(12.0),
                          BlocBuilder<CommonBloc, CommonBlocStates>(
                            builder: (context, state) {
                              if (state is CommonBlocSelectImageState) {
                                outletPhotoFile = state.imageFile;
                              }
                              return InkWell(
                                onTap: () {
                                  selectImage(outletName);
                                },
                                child: selectImageWidget(outletName),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBoxWidget(17.0),
                          textWidget(ownerPhoto),
                          sizedBoxWidget(12.0),
                          BlocBuilder<CommonBloc, CommonBlocStates>(
                            builder: (context, state) {
                              if (state is CommonBlocSelectOwnerImageState) {
                                ownerPhotoFile = state.imageFile;
                              }
                              return InkWell(
                                onTap: () {
                                  selectImage(ownerName);
                                },
                                child: selectImageWidget(ownerName),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  sizedBoxWidget(10.0),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: MaterialButton(
          height: 50,
          minWidth: MediaQuery.of(context).size.width,
          color: MColor.colorSecondary,
          textColor: Colors.white,
          onPressed: () async {
            if (selectEnrollmentRadio == "") {
              Fluttertoast.showToast(msg: "Please select enrollment type");
            } else if (txtSelectBeatNameController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select beat name");
            } else if (txtOutletNameController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter outlet name");
            } else if (txtOwnerNameController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter owner name");
            } else if (txtLandmarkController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter landmark");
            } else if (txtPrimaryMobController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter primary mobile");
            } else if (existingRetailerRadio == "") {
              Fluttertoast.showToast(msg: "Please select existing retailer");
            } else if (txtSelectCallTimeSlotController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select call time slot");
            } else if (txtSelectLangFirstController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select language 1st");
            } else if (txtSelectRetailerTypeController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select retailer type");
            } else if (txtSelectRetailerCategoryController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select retailer category");
            } else if (whatsAppSmsRadio == "") {
              Fluttertoast.showToast(
                  msg: "Please select opt-in for whatsapp message / SMS");
            } else if (outletPhotoFile == null) {
              Fluttertoast.showToast(msg: "Please capture outlet photo");
            } else {
              Fluttertoast.showToast(msg: "Store added successful");
            }

            String userId = await SharedPreference.getStringPreference(
                SharedPreference.userId);
            debugPrint("edit store userId $userId");
            debugPrint("edit store enrollmentTypeId $enrollmentTypeId");
            debugPrint("edit store cityId $cityId");
            debugPrint("edit store distributorId $distributorId");
            debugPrint("edit store beatId $beatId");
            debugPrint("edit store orderBookingDayId $orderBookingDayId");
            debugPrint("edit store outletName ${txtOutletNameController.text}");
            debugPrint("edit store ownerName ${txtOwnerNameController.text}");
            debugPrint("edit store latitude ${txtLatitudeController.text}");
            debugPrint("edit store longitude ${txtLongtitudeController.text}");
            debugPrint("edit store address ${txtAddressController.text}");
            debugPrint("edit store landmark ${txtLandmarkController.text}");
            debugPrint("edit store pincode ${txtPincodeController.text}");
            debugPrint(
                "edit store primaryMobile ${txtPrimaryMobController.text}");
            debugPrint(
                "edit store secondaryMobile ${txtSecondaryMobController.text}");
            if (existingRetailerRadio == yes) {
              debugPrint("edit store existingRetailer $yes");
            } else {
              debugPrint("edit store existingRetailer $no");
            }

            debugPrint("edit store callTimeSlotId $callTimeSlotId");
            debugPrint("edit store primaryLangId $primaryLangId");
            debugPrint("edit store secondaryLangId $secondaryLangId");
            debugPrint("edit store retailerTypeId $retailerTypeId");
            debugPrint("edit store retailerCategoryId $retailerCategoryId");
            if (whatsAppSmsRadio == yes) {
              debugPrint("edit store whatsAppMessage $yes");
            } else {
              debugPrint("edit store whatsAppMessage $no");
            }
            if (isKRORadio == yes) {
              debugPrint("edit store isKRO $yes");
            } else {
              debugPrint("edit store isKRO $no");
            }

            debugPrint("edit store gstNo ${txtGSTController.text}");
            debugPrint("edit store panNo ${txtPANController.text}");
            debugPrint("edit store aadhar ${txtAdharNumberController.text}");
            debugPrint("edit store email ${txtEmailController.text}");
            debugPrint("edit store birthday ${txtPicDateController.text}");
            debugPrint("edit store outletphoto $outletFileName");
            debugPrint("edit store ownerPhoto $ownerFileName");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                updateCaps,
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
    );
  }

  Widget sizedBoxWidget(boxHeight) {
    return SizedBox(
      height: boxHeight,
    );
  }

  Widget textFields(txtController, textHint) {
    return txtController == txtPicDateController ||
            txtController == txtSelectCityController ||
            txtController == txtSelectDistributorController ||
            txtController == txtSelectBeatNameController ||
            txtController == txtSelectCallTimeSlotController ||
            txtController == txtSelectLangFirstController ||
            txtController == txtSelectLangSecondController ||
            txtController == txtSelectRetailerTypeController ||
            txtController == txtSelectRetailerCategoryController
        ? GestureDetector(
            onTap: () async {
              if (txtController == txtPicDateController) {
                dateTime ??= await NTP.now();
                dateTime = await showDatePicker(
                  context: context,
                  initialDate: dateTime!,
                  firstDate: DateTime(1950),
                  lastDate: await NTP.now(),
                );
                if (dateTime != null) {
                  commonBloc
                      .add(CommonBlocSelectDateEvent(dateTime: dateTime!));
                }
              } else {
                openBottomSheet(context, txtController);
              }
            },
            child: TextFormField(
              enabled: false,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.67,
                color: MColor.backButton,
              ),
              controller: txtController,
              decoration: InputDecoration(
                suffixIcon: txtController == txtPicDateController
                    ? const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          widthFactor: 1,
                          alignment: Alignment.centerRight,
                          child: Image(
                            width: 22,
                            image: AssetImage("assets/calendar_icon.png"),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: MColor.backButton,
                          size: 30,
                        ),
                      ),
                hintText: textHint,
                hintStyle: const TextStyle(
                  color: MColor.backButton,
                  letterSpacing: 0.67,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                filled: true,
                fillColor: const Color(0xffF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
        : TextFormField(
            keyboardType: txtController == txtPincodeController ||
                    txtController == txtPrimaryMobController ||
                    txtController == txtSecondaryMobController ||
                    txtController == txtAdharNumberController
                ? TextInputType.number
                : txtController == txtEmailController
                    ? TextInputType.emailAddress
                    : TextInputType.text,
            controller: txtController,
            maxLength: txtController == txtPrimaryMobController ||
                    txtController == txtSecondaryMobController
                ? 10
                : null,
            enabled: txtController == txtLatitudeController ||
                    txtController == txtLongtitudeController ||
                    txtController == txtPincodeController ||
                    txtController == txtOrderBookingController
                ? false
                : true,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.67,
              color: MColor.backButton,
            ),
            decoration: InputDecoration(
              hintText: textHint,
              hintStyle: const TextStyle(
                color: MColor.backButton,
                letterSpacing: 0.67,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              filled: true,
              fillColor: const Color(0xffF2F2F2),
              counter: Container(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          );
  }

  Widget textWidget(currentText) {
    return Text(
      currentText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.67,
        fontSize: 17,
        color: Colors.black,
      ),
    );
  }

  Widget radioButtonWidget(groupValue, value, label) {
    void addRadioEvent() {
      if (value == 1 || value == 2) {
        commonBloc.add(CommonBlocRetailerRadioEvent(retailerRadioTag: value));
      }
      if (value == 3 || value == 4) {
        commonBloc.add(CommonBlocWhatsAppRadioEvent(whatsAppRadioTag: value));
      }
      if (value == 5 || value == 6) {
        commonBloc.add(CommonBlocIsKRORadioEvent(isKRORadioTag: value));
      }
    }

    return GestureDetector(
      onTap: () {
        addRadioEvent();
      },
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Radio<dynamic>(
              value: value,
              groupValue: groupValue,
              activeColor: MColor.colorPrimary,
              fillColor: MaterialStateProperty.all(MColor.colorPrimary),
              onChanged: (value) {
                addRadioEvent();
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 17.0,
              color: MColor.backButton,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  List<Widget> radioButtonWidgetList() {
    List<Widget> widgets = [];
    for (EnrolmentTypeModel enrolmentType in enrolmentTypeModel!) {
      widgets.add(GestureDetector(
        onTap: () {
          commonBloc.add(CommonBlocEnrollTypeRadioEvent(
              enrollmentRadioTag: enrolmentType.id));
          enrollmentTypeId = enrolmentType.id;
        },
        child: Row(
          children: [
            SizedBox(
              width: 18,
              child: Radio<dynamic>(
                value: enrolmentType.id,
                groupValue: selectEnrollmentRadio,
                activeColor: MColor.colorPrimary,
                fillColor: MaterialStateProperty.all(MColor.colorPrimary),
                onChanged: (value) {
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(
                      enrollmentRadioTag: value));
                  enrollmentTypeId = enrolmentType.id;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              enrolmentType.enrollmentType,
              style: const TextStyle(
                fontSize: 17.0,
                color: MColor.backButton,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ));
    }
    return widgets;
  }

  Widget selectImageWidget(imageLabel) {
    return Container(
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
      child: imageLabel == outletName
          ? (outletPhotoFile == null
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
                    image: FileImage(outletPhotoFile!),
                    fit: BoxFit.cover,
                  ),
                ))
          : ownerPhotoFile == null
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
                    image: FileImage(ownerPhotoFile!),
                    fit: BoxFit.cover,
                  ),
                ),
    );
  }

  void selectImage(imageLabel) async {
    try {
      XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 512,
          maxWidth: 512,
          preferredCameraDevice: CameraDevice.front);
      if (image != null) {
        if (imageLabel == outletName) {
          outletPhotoFile = File(image.path);
          outletFileName = image.name;
          commonBloc
              .add(CommonBlocSelectImageEvent(imageFile: outletPhotoFile!));
        } else {
          ownerPhotoFile = File(image.path);
          ownerFileName = image.name;
          commonBloc
              .add(CommonBlocSelectOwnerImageEvent(imageFile: ownerPhotoFile!));
        }
      }
    } catch (exception) {
      Fluttertoast.showToast(
          msg:
              "Permission denied, go to app settings and allow camera permission",
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void openBottomSheet(BuildContext context, txtController) async {
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) {
          return txtController == txtSelectCityController
              ? SelectCityBottomSheet(
                  selectedCityName: txtSelectCityController.text.isEmpty
                      ? ""
                      : txtSelectCityController.text,
                  onCitySelect: (city, id) {
                    txtSelectCityController.text = city;
                    if (id != null) {
                      cityId = id;
                    }
                  },
                )
              : txtController == txtSelectDistributorController
                  ? SelectDistributorBottomSheet(
                      selectedDistributorName:
                          txtSelectDistributorController.text.isEmpty
                              ? ""
                              : txtSelectDistributorController.text,
                      onDistributorSelect: (distributor, id) {
                        txtSelectDistributorController.text = distributor;
                        if (id != null) {
                          distributorId = id;
                        }
                      },
                    )
                  : txtController == txtSelectBeatNameController
                      ? SelectBeatNameBottomSheet(
                          selectedBeatNameName:
                              txtSelectBeatNameController.text.isEmpty
                                  ? ""
                                  : txtSelectBeatNameController.text,
                          onBeatNameSelect: (beatName) {
                            txtSelectBeatNameController.text = beatName;
                            // txtOrderBookingController.text = beatName;
                          },
                        )
                      : txtController == txtSelectLangFirstController
                          ? SelectLanguageBottomSheet(
                              selectedLanguageName:
                                  txtSelectLangFirstController.text.isEmpty
                                      ? ""
                                      : txtSelectLangFirstController.text,
                              onLanguageSelect: (languageName, id) {
                                txtSelectLangFirstController.text =
                                    languageName;
                                if (id != null) {
                                  primaryLangId = id;
                                }
                              },
                              bottomSheetHeading: "1",
                              previousSelectedLang:
                                  txtSelectLangSecondController.text,
                            )
                          : txtController == txtSelectLangSecondController
                              ? SelectLanguageBottomSheet(
                                  selectedLanguageName:
                                      txtSelectLangSecondController.text.isEmpty
                                          ? ""
                                          : txtSelectLangSecondController.text,
                                  onLanguageSelect: (languageName, id) {
                                    txtSelectLangSecondController.text =
                                        languageName;
                                    if (id != null) {
                                      secondaryLangId = id;
                                    }
                                  },
                                  bottomSheetHeading: "2",
                                  previousSelectedLang:
                                      txtSelectLangFirstController.text,
                                )
                              : txtController == txtSelectCallTimeSlotController
                                  ? SelectCallTimeSlotBottomSheet(
                                      selectedCallTimeSlotName:
                                          txtSelectCallTimeSlotController
                                                  .text.isEmpty
                                              ? ""
                                              : txtSelectCallTimeSlotController
                                                  .text,
                                      onCallTimeSlotSelect: (callTimeSlot, id) {
                                        txtSelectCallTimeSlotController.text =
                                            callTimeSlot;
                                        if (id != null) {
                                          callTimeSlotId = id;
                                        }
                                      },
                                    )
                                  : txtController ==
                                          txtSelectRetailerTypeController
                                      ? SelectRetailerTypeBottomSheet(
                                          selectedRetailerTypeName:
                                              txtSelectRetailerTypeController
                                                      .text.isEmpty
                                                  ? ""
                                                  : txtSelectRetailerTypeController
                                                      .text,
                                          onRetailerTypeSelect:
                                              (retailerType, id) {
                                            txtSelectRetailerTypeController
                                                .text = retailerType;
                                            if (id != null) {
                                              retailerTypeId = id;
                                            }
                                          },
                                        )
                                      : SelectRetailerCategoryBottomSheet(
                                          selectedRetailerCategoryName:
                                              txtSelectRetailerCategoryController
                                                      .text.isEmpty
                                                  ? ""
                                                  : txtSelectRetailerCategoryController
                                                      .text,
                                          onRetailerCategorySelect:
                                              (retailerCategory, id) {
                                            txtSelectRetailerCategoryController
                                                .text = retailerCategory;
                                            if (id != null) {
                                              retailerCategoryId = id;
                                            }
                                          },
                                        );
        });
  }

  void onRefresh() async {
    editStoreBloc.add(GetEnrolmentTypeEvent());
    userLocationBloc.add(GetUserLocationEvent());
    refreshController.refreshCompleted();
  }
}
