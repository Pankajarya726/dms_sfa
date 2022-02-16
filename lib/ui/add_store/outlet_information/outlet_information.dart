import 'dart:collection';
import 'dart:io';

import 'package:dms/ui/add_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/add_store/bloc/edit_store_events.dart';
import 'package:dms/ui/add_store/bloc/edit_store_states.dart';
import 'package:dms/ui/add_store/model/editstore_getenroll_type_response.dart';
import 'package:dms/ui/add_store/owner_information/owner_information.dart';
import 'package:dms/ui/bottom_sheet_widget/select_beat_name_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_distributor_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_district_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_retailercategory_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_retailertype_bottom_sheet.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_bloc.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_events.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/shared_preference.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../main.dart';

class OutletInformation extends StatefulWidget {
  const OutletInformation({Key? key}) : super(key: key);

  @override
  State<OutletInformation> createState() => _OutletInformationState();
}

class _OutletInformationState extends State<OutletInformation> {
  Object selectEnrollmentRadio = "";
  Object existingRetailerRadio = "";
  Object isKRORadio = "";
  File? outletPhotoFile;
  String? outletFileName;
  CommonBloc commonBloc = CommonBloc();
  UserLocationBloc userLocationBloc = UserLocationBloc();
  EditStoreBloc editStoreBloc = EditStoreBloc();
  TextEditingController txtSelectDistrictController = TextEditingController();
  TextEditingController txtSelectDistributorController = TextEditingController();
  TextEditingController txtSelectBeatNameController = TextEditingController();
  TextEditingController txtOrderBookingController = TextEditingController();
  TextEditingController txtOutletNameController = TextEditingController();
  TextEditingController txtLatitudeController = TextEditingController();
  TextEditingController txtLongtitudeController = TextEditingController();
  TextEditingController txtAddressController = TextEditingController();
  TextEditingController txtPincodeController = TextEditingController();
  TextEditingController txtLandmarkController = TextEditingController();
  TextEditingController txtSelectRetailerTypeController = TextEditingController();
  TextEditingController txtSelectRetailerCategoryController = TextEditingController();
  TextEditingController txtGSTController = TextEditingController();
  List<EnrolmentTypeModel>? enrolmentTypeModel = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  int? enrollmentTypeId;
  int? districtId;
  int? distributorId;
  int? beatId;
  int? orderBookingDayId;
  int? retailerTypeId;
  int? retailerCategoryId;
  GlobalKey globalKey = GlobalKey();
  TextEditingController selectedController = TextEditingController();

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
            outletInfo,
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
                  Row(
                    children: [
                      Image.asset("assets/docs.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(enrollmentType),
                    ],
                  ),
                  sizedBoxWidget(5.0, ""),
                  BlocBuilder<EditStoreBloc, EditStoreStates>(builder: (context, state) {
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
                  sizedBoxWidget(5.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/building.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(district),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtSelectDistrictController, selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/truck.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(distributor),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtSelectDistributorController, selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/map.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(beatNameMandatory),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtSelectBeatNameController, selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/calendar.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(orderBookingDay),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtOrderBookingController, day),
                  sizedBoxWidget(12.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/store.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(outletName),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtOutletNameController, enterHere),
                  sizedBoxWidget(12.0, ""),
                  BlocBuilder<UserLocationBloc, UserLocationStates>(
                    bloc: userLocationBloc,
                    builder: (context, state) {
                      debugPrint("state---->$state");

                      if (state is UserLocationInitialState) {
                        userLocationBloc.add(GetUserLocationEvent());
                      }

                      if (state is GetUserLocationState) {
                        if (txtLatitudeController.text != state.latitude.toString() &&
                            txtLongtitudeController.text != state.longitude.toString()) {
                          txtLatitudeController.text = state.latitude.toString();
                          txtLongtitudeController.text = state.longitude.toString();
                          txtAddressController.text = state.currentAddress;
                          txtPincodeController.text = state.pincode;
                        }
                      }

                      if (state is UserLocationFailureState) {
                        Fluttertoast.showToast(msg: "Please turn on GPS to get current location");
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/lat_long.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              textWidget(latitude),
                            ],
                          ),
                          sizedBoxWidget(12.0, txtOutletNameController),
                          textFields(txtLatitudeController, enterHere),
                          sizedBoxWidget(12.0, ""),
                          Row(
                            children: [
                              Image.asset("assets/lat_long.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              textWidget(longitude),
                            ],
                          ),
                          sizedBoxWidget(12.0, ""),
                          textFields(txtLongtitudeController, enterHere),
                          sizedBoxWidget(12.0, ""),
                          Row(
                            children: [
                              Image.asset("assets/address.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              textWidget(address),
                            ],
                          ),
                          sizedBoxWidget(12.0, ""),
                          textFields(txtAddressController, enterHere),
                          sizedBoxWidget(12.0, ""),
                          Row(
                            children: [
                              Image.asset("assets/pin_code.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              textWidget(pincode),
                            ],
                          ),
                          sizedBoxWidget(12.0, txtAddressController),
                          textFields(txtPincodeController, enterHere),
                          sizedBoxWidget(12.0, ""),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      Image.asset("assets/landmark.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(landmark),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtLandmarkController, enterHere),
                  sizedBoxWidget(12.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/user.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(existingRetailer),
                    ],
                  ),
                  sizedBoxWidget(5.0, ""),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocRetailerRadioState) {
                        existingRetailerRadio = state.retailerRadioTag;
                        debugPrint("$existingRetailerRadio");
                      }
                      return Row(
                        children: [
                          sizedBoxWidget(0.0, txtLandmarkController),
                          radioButtonWidget(existingRetailerRadio, 1, yes),
                          radioButtonWidget(existingRetailerRadio, 2, no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/store.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(retailerTypeMand),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtSelectRetailerTypeController, selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/categories.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(retailerCategoryMand),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtSelectRetailerCategoryController, selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/question.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(isKRO),
                    ],
                  ),
                  sizedBoxWidget(5.0, ""),
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
                  sizedBoxWidget(5.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/document.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(gstNo),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtGSTController, enterHere),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxWidget(12.0, ""),
                      Row(
                        children: [
                          Image.asset("assets/gallery.png"),
                          const SizedBox(
                            width: 10,
                          ),
                          textWidget(outletPhoto),
                        ],
                      ),
                      sizedBoxWidget(12.0, txtGSTController),
                      BlocBuilder<CommonBloc, CommonBlocStates>(
                        builder: (context, state) {
                          if (state is CommonBlocSelectImageState) {
                            outletPhotoFile = state.imageFile;
                          }
                          return InkWell(
                            onTap: () {
                              selectImage();
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
                  sizedBoxWidget(5.0, ""),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: MaterialButton(
          height: 50,
          minWidth: MediaQuery.of(context).size.width,
          color: MColor.colorPrimary,
          textColor: Colors.white,
          onPressed: () async {
            Utility.hideKeyboard();
            FocusScope.of(context).unfocus();
            if (selectEnrollmentRadio == "") {
              Fluttertoast.showToast(msg: "Please select enrollment type");
            } else if (txtSelectBeatNameController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select beat name");
            } else if (txtOutletNameController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter outlet name");
            } else if (txtLandmarkController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter landmark");
            } else if (existingRetailerRadio == "") {
              Fluttertoast.showToast(msg: "Please select existing retailer");
            } else if (txtSelectRetailerTypeController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select retailer type");
            } else if (txtSelectRetailerCategoryController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select retailer category");
            } else if (outletPhotoFile == null) {
              Fluttertoast.showToast(msg: "Please capture outlet photo");
            } else {
              String userId = await SharedPreference.getStringPreference(SharedPreference.userId);
              debugPrint("edit store userId $userId");
              debugPrint("edit store enrollmentTypeId $enrollmentTypeId");
              debugPrint("edit store cityId $districtId");
              debugPrint("edit store distributorId $distributorId");
              debugPrint("edit store beatId $beatId");
              debugPrint("edit store orderBookingDayId $orderBookingDayId");
              debugPrint("edit store outletName ${txtOutletNameController.text}");
              debugPrint("edit store latitude ${txtLatitudeController.text}");
              debugPrint("edit store longitude ${txtLongtitudeController.text}");
              debugPrint("edit store address ${txtAddressController.text}");
              debugPrint("edit store landmark ${txtLandmarkController.text}");
              debugPrint("edit store pincode ${txtPincodeController.text}");

              if (existingRetailerRadio == yes) {
                debugPrint("edit store existingRetailer $yes");
              } else {
                debugPrint("edit store existingRetailer $no");
              }

              debugPrint("edit store retailerTypeId $retailerTypeId");
              debugPrint("edit store retailerCategoryId $retailerCategoryId");

              if (isKRORadio == yes) {
                debugPrint("edit store isKRO $yes");
              } else {
                debugPrint("edit store isKRO $no");
              }

              debugPrint("edit store gstNo ${txtGSTController.text}");
              debugPrint("edit store outletphoto $outletFileName");

              Map<String, dynamic> outletInfo = HashMap<String, dynamic>();
              outletInfo["user_id"] = await SharedPreference.getStringPreference(SharedPreference.userId);
              outletInfo["enrolment_type"] = enrollmentTypeId;
              outletInfo["district_id"] = districtId;
              outletInfo["distributor_id"] = distributorId;
              outletInfo["beat_id"] = beatId;
              outletInfo["order_booking_day_id"] = orderBookingDayId;
              outletInfo["outlet_name"] = txtOutletNameController.text;
              outletInfo["latitude"] = txtLatitudeController.text;
              outletInfo["longitude"] = txtLongtitudeController.text;
              outletInfo["address"] = txtAddressController.text;
              outletInfo["pincode"] = txtPincodeController.text;
              outletInfo["landmark"] = txtLandmarkController.text;
              outletInfo["existing_retailer"] = existingRetailerRadio;
              outletInfo["retailer_type"] = txtSelectRetailerTypeController.text;
              outletInfo["retailer_category"] = txtSelectRetailerCategoryController.text;
              outletInfo["is_kro"] = isKRORadio;
              outletInfo["gst_number"] = txtGSTController.text;
              outletInfo["outlet_photo"] = outletPhotoFile;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OwnerInformation(outletInfo: outletInfo)),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                nextCaps,
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

  Widget sizedBoxWidget(boxHeight, txtController) {
    return SizedBox(
      key: selectedController == txtController ? globalKey : null,
      height: boxHeight,
    );
  }

  Widget textFields(txtController, textHint) {
    return txtController == txtSelectDistrictController ||
            txtController == txtSelectDistributorController ||
            txtController == txtSelectBeatNameController ||
            txtController == txtSelectRetailerTypeController ||
            txtController == txtSelectRetailerCategoryController
        ? GestureDetector(
            onTap: () async {
              openBottomSheet(context, txtController);
            },
            child: TextFormField(
              enabled: false,
              autofocus: false,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.67,
                color: MColor.backButton,
              ),
              controller: txtController,
              decoration: InputDecoration(
                suffixIcon: const Padding(
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
            onFieldSubmitted: (value) {
              selectedController = TextEditingController();
            },
            autofocus: false,
            onTap: () async {
              selectedController = txtController;
              await Future.delayed(const Duration(milliseconds: 500));
              RenderObject? object = globalKey.currentContext!.findRenderObject();
              object!.showOnScreen();
            },
            keyboardType: TextInputType.text,
            controller: txtController,
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
          commonBloc.add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: enrolmentType.id));
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
                  commonBloc.add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value));
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
      child: outletPhotoFile == null
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
            ),
    );
  }

  void selectImage() async {
    try {
      XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 512, maxWidth: 512, preferredCameraDevice: CameraDevice.front);
      if (image != null) {
        outletPhotoFile = File(image.path);
        outletFileName = image.name;
        commonBloc.add(CommonBlocSelectImageEvent(imageFile: outletPhotoFile!));
      }
    } catch (exception) {
      Fluttertoast.showToast(msg: "Permission denied, go to app settings and allow camera permission", toastLength: Toast.LENGTH_LONG);
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
          return txtController == txtSelectDistrictController
              ? SelectDistrictBottomSheet(
                  selectedDistrictName: txtSelectDistrictController.text.isEmpty ? "" : txtSelectDistrictController.text,
                  onDistrictSelect: (district, id) {
                    txtSelectDistrictController.text = district;
                    if (id != null) {
                      districtId = id;
                      txtSelectDistributorController.text = "";
                      txtSelectBeatNameController.text = "";
                      txtOrderBookingController.text = "";
                    }
                  },
                )
              : txtController == txtSelectDistributorController
                  ? SelectDistributorBottomSheet(
                      selectedDistributorName: txtSelectDistributorController.text.isEmpty ? "" : txtSelectDistributorController.text,
                      onDistributorSelect: (distributor, id) {
                        txtSelectDistributorController.text = distributor;
                        if (id != null) {
                          distributorId = id;
                          txtSelectBeatNameController.text = "";
                          txtOrderBookingController.text = "";
                        }
                      },
                    )
                  : txtController == txtSelectBeatNameController
                      ? SelectBeatNameBottomSheet(
                          selectedBeatNameName: txtSelectBeatNameController.text.isEmpty ? "" : txtSelectBeatNameController.text,
                          onBeatNameSelect: (beatName) {
                            txtSelectBeatNameController.text = beatName;
                            // txtOrderBookingController.text = beatName;
                          },
                        )
                      : txtController == txtSelectRetailerTypeController
                          ? SelectRetailerTypeBottomSheet(
                              selectedRetailerTypeName:
                                  txtSelectRetailerTypeController.text.isEmpty ? "" : txtSelectRetailerTypeController.text,
                              onRetailerTypeSelect: (retailerType, id) {
                                txtSelectRetailerTypeController.text = retailerType;
                                if (id != null) {
                                  retailerTypeId = id;
                                }
                              },
                            )
                          : SelectRetailerCategoryBottomSheet(
                              selectedRetailerCategoryName:
                                  txtSelectRetailerCategoryController.text.isEmpty ? "" : txtSelectRetailerCategoryController.text,
                              onRetailerCategorySelect: (retailerCategory, id) {
                                txtSelectRetailerCategoryController.text = retailerCategory;
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
