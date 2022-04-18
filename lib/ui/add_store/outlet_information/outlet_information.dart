import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:dms/model/retailer_form.dart';
import 'package:dms/ui/add_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/add_store/bloc/edit_store_events.dart';
import 'package:dms/ui/add_store/bloc/edit_store_states.dart';
import 'package:dms/ui/add_store/model/editstore_getenroll_type_response.dart';
import 'package:dms/ui/add_store/model/orderbooking_day_response.dart';
import 'package:dms/ui/add_store/model/select_distributor_response.dart';
import 'package:dms/ui/add_store/model/select_district_response.dart';
import 'package:dms/ui/add_store/model/select_retailer_category_response.dart';
import 'package:dms/ui/add_store/model/select_retailer_type_response.dart';
import 'package:dms/ui/add_store/owner_information/owner_information.dart';
import 'package:dms/ui/bottom_sheet_widget/select_beat_name_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_distributor_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_district_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_retailercategory_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_retailertype_bottom_sheet.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/ui/custom_widget/input_widget.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
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
  RetailerForm form = RetailerForm();
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
  String? enrollmentTypeId;
  EnrolmentTypeModel? enrolmentType;
  DistrictModel? districtModel;
  DistributorModel? distributorModel;
  BeatsModal? beatModal;
  RetailerTypeModel? retailerTypeModel;
  RetailerCategoryModel? retailerCategoryModal;
  String? districtId;
  String? distributorId;
  String? orderBookingDayId;
  String? retailerTypeId;
  String? retailerCategoryId;
  GlobalKey globalKeyLandmark = GlobalKey();
  GlobalKey globalKeyName = GlobalKey();
  GlobalKey globalKeyGST = GlobalKey();
  GlobalKey globalKeyAddress = GlobalKey();
  List<OrderBookingDayModal> orderBookingDayList = [];

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
            StringConst.outletInfo,
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
                      textWidget(StringConst.enrollmentType),
                    ],
                  ),
                  sizedBoxWidget(5.0),
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
                  sizedBoxWidget(5.0),
                  Row(
                    children: [
                      Image.asset("assets/building.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.district),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectDistrictController, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    children: [
                      Image.asset("assets/truck.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.distributor),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectDistributorController, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    children: [
                      Image.asset("assets/map.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.beatNameMandatory),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectBeatNameController, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    children: [
                      Image.asset("assets/calendar.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.orderBookingDay),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  FreezedEditText(
                    controller: txtOrderBookingController,
                    hint: StringConst.day,
                    onChange: (text) {
                      txtOrderBookingController.text = text;
                    },
                  ),
                  sizedBoxWidget(12.0),
                  Row(
                    children: [
                      Image.asset("assets/store.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.outletName),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  NameEditText(
                    controller: txtOutletNameController,
                    hint: StringConst.enterHere,
                    globalKey: globalKeyName,
                    onChange: (text) {
                      form.outletName = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
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
                              textWidget(StringConst.latitude),
                            ],
                          ),
                          SizedBox(
                            key: globalKeyName,
                            height: 12.0,
                          ),
                          FreezedEditText(
                            controller: txtLatitudeController,
                            hint: StringConst.enterHere,
                            onChange: (text) {
                              txtLatitudeController.text = text;
                            },
                          ),
                          sizedBoxWidget(12.0),
                          Row(
                            children: [
                              Image.asset("assets/lat_long.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              textWidget(StringConst.longitude),
                            ],
                          ),
                          sizedBoxWidget(12.0),
                          FreezedEditText(
                            controller: txtLongtitudeController,
                            hint: StringConst.enterHere,
                            onChange: (text) {
                              txtLongtitudeController.text = text;
                            },
                          ),
                          sizedBoxWidget(12.0),
                          Row(
                            children: [
                              Image.asset("assets/address.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              textWidget(StringConst.address),
                            ],
                          ),
                          sizedBoxWidget(12.0),
                          NormalEditText(
                            controller: txtAddressController,
                            onChange: (text) {
                              txtAddressController.text = text;
                            },
                            globalKey: globalKeyAddress,
                            name: StringConst.address,
                          ),
                          sizedBoxWidget(12.0),
                          Row(
                            children: [
                              Image.asset("assets/pin_code.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              textWidget(StringConst.pincode),
                            ],
                          ),
                          SizedBox(
                            key: globalKeyAddress,
                            height: 12.0,
                          ),
                          FreezedEditText(
                            controller: txtPincodeController,
                            hint: StringConst.enterHere,
                            onChange: (text) {
                              txtPincodeController.text = text;
                            },
                          ),
                          sizedBoxWidget(12.0),
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
                      textWidget(StringConst.landmark),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  NormalEditText(
                    controller: txtLandmarkController,
                    onChange: (text) {
                      txtLandmarkController.text = text;
                    },
                    globalKey: globalKeyLandmark,
                    name: StringConst.landmark,
                  ),
                  sizedBoxWidget(12.0),
                  Row(
                    children: [
                      Image.asset("assets/user.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.existingRetailer),
                    ],
                  ),
                  sizedBoxWidget(5.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocRetailerRadioState) {
                        existingRetailerRadio = state.retailerRadioTag;
                        debugPrint("$existingRetailerRadio");
                      }
                      return Row(
                        children: [
                          SizedBox(
                            key: globalKeyLandmark,
                          ),
                          radioButtonWidget(existingRetailerRadio, 1, StringConst.yes),
                          radioButtonWidget(existingRetailerRadio, 2, StringConst.no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0),
                  Row(
                    children: [
                      Image.asset("assets/store.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.retailerTypeMand),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectRetailerTypeController, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    children: [
                      Image.asset("assets/categories.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.retailerCategoryMand),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  textFields(txtSelectRetailerCategoryController, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    children: [
                      Image.asset("assets/question.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.isKRO),
                    ],
                  ),
                  sizedBoxWidget(5.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocIsKRORadioState) {
                        isKRORadio = state.isKRORadioTag;
                        debugPrint("$isKRORadio");
                      }
                      return Row(
                        children: [
                          radioButtonWidget(isKRORadio, 3, StringConst.yes),
                          radioButtonWidget(isKRORadio, 4, StringConst.no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0),
                  Row(
                    children: [
                      Image.asset("assets/document.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.gstNo),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  GSTEditText(
                    controller: txtGSTController,
                    hint: StringConst.enterHere,
                    globalKey: globalKeyGST,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxWidget(20.0),
                      Row(
                        children: [
                          Image.asset("assets/gallery.png"),
                          const SizedBox(
                            width: 10,
                          ),
                          textWidget(StringConst.outletPhoto),
                        ],
                      ),
                      SizedBox(
                        key: globalKeyGST,
                        height: 10.0,
                      ),
                      BlocBuilder<CommonBloc, CommonBlocStates>(
                        builder: (context, state) {
                          if (state is CommonBlocSelectImageState) {
                            outletPhotoFile = state.imageFile;
                          }
                          return InkWell(
                            onTap: () {
                              selectImage();
                            },
                            child: selectImageWidget(StringConst.outletName),
                          );
                        },
                      ),
                    ],
                  ),
                  sizedBoxWidget(5.0),
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
            if (selectEnrollmentRadio == "") {
              Utility.showToast("Please select enrollment type");
            } else if (txtSelectBeatNameController.text.isEmpty) {
              Utility.showToast("Please select beat name");
            } else if (txtOutletNameController.text.isEmpty) {
              Utility.showToast("Please enter outlet name");
            } else if (txtLandmarkController.text.isEmpty) {
              Utility.showToast("Please enter landmark");
            } else if (existingRetailerRadio == "") {
              Utility.showToast("Please select existing retailer");
            } else if (txtSelectRetailerTypeController.text.isEmpty) {
              Utility.showToast("Please select retailer type");
            } else if (txtSelectRetailerCategoryController.text.isEmpty) {
              Utility.showToast("Please select retailer category");
            } else if (outletPhotoFile == null) {
              Utility.showToast("Please capture outlet photo");
            } else if (txtGSTController.text.length < 15 && txtGSTController.text.isNotEmpty) {
              Utility.showToast("Please enter valid GST number");
            } else {
              String userId = await SharedPreference.getStringPreference(SharedPreference.userId);
              debugPrint("edit store userId $userId");
              debugPrint("edit store enrollmentTypeId $enrollmentTypeId");
              debugPrint("edit store cityId $districtId");
              debugPrint("edit store distributorId $distributorId");
              debugPrint("edit store beatId ${beatModal!.id}");
              debugPrint("edit store orderBookingDayId $orderBookingDayId");
              debugPrint("edit store outletName ${txtOutletNameController.text}");
              debugPrint("edit store latitude ${txtLatitudeController.text}");
              debugPrint("edit store longitude ${txtLongtitudeController.text}");
              debugPrint("edit store address ${txtAddressController.text}");
              debugPrint("edit store landmark ${txtLandmarkController.text}");
              debugPrint("edit store pincode ${txtPincodeController.text}");

              if (existingRetailerRadio == 1) {
                debugPrint("edit store existingRetailer 1");
              } else {
                debugPrint("edit store existingRetailer 0");
              }

              debugPrint("edit store retailerTypeId $retailerTypeId");
              debugPrint("edit store retailerCategoryId $retailerCategoryId");

              if (isKRORadio == 3) {
                debugPrint("edit store isKRO 1");
              } else {
                debugPrint("edit store isKRO 0");
              }

              debugPrint("edit store gstNo ${txtGSTController.text}");
              debugPrint("edit store outletphoto $outletFileName");

              form.districtId = districtId ?? "";
              form.distributorId = distributorId ?? "";
              form.beatId = beatModal != null ? beatModal!.id.toString() : "";
              form.orderBookingDay1 = orderBookingDayId ?? "";
              form.outletName = txtOutletNameController.text.trim();
              form.latitude = txtLatitudeController.text.trim();
              form.longitude = txtLongtitudeController.text.trim();
              form.address = txtAddressController.text.trim();
              form.pinCode = txtPincodeController.text.trim();
              form.landmark = txtLandmarkController.text.trim();
              form.isExistingRetailer = existingRetailerRadio == 1 ? "1" : "0";
              form.retailerTypeId = retailerTypeId ?? "";
              form.retailerCategoryId = retailerCategoryId ?? "";
              form.isKro = isKRORadio == 3 ? "1" : "0";
              form.gstNo = txtGSTController.text.trim();
              form.outletImage = outletPhotoFile == null ? "" : outletPhotoFile!.path;

              log("retailer-from---->${form.toMap().toString()}");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OwnerInformation(
                    form: form,
                  ),
                ),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                StringConst.nextCaps,
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
    return TextFormField(
      onTap: () async {
        openBottomSheet(context, txtController);
      },
      readOnly: true,
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
        commonBloc.add(CommonBlocIsKRORadioEvent(isKRORadioTag: value));
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
          enrollmentTypeId = enrolmentType.id.toString();
          form.enrollmentTypeId = enrolmentType.id.toString();
          form.enrollmentType = enrolmentType.enrollmentType.toString();
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
                  enrollmentTypeId = enrolmentType.id.toString();
                  form.enrollmentTypeId = enrolmentType.id.toString();
                  form.enrollmentType = enrolmentType.enrollmentType.toString();
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
    FocusScope.of(context).unfocus();
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
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) {
          return txtController == txtSelectDistrictController
              ? SelectDistrictBottomSheet(
                  districtModel: districtModel,
                  onDistrictSelect: (district) {
                    if (district != null) {
                      districtModel = district;
                      txtSelectDistrictController.text = district.name;
                      districtId = district.id.toString();
                    }
                    txtSelectDistributorController.text = "";
                    txtSelectBeatNameController.text = "";
                    txtOrderBookingController.text = "";
                    distributorModel = null;
                    beatModal = null;
                  },
                )
              : txtController == txtSelectDistributorController
                  ? SelectDistributorBottomSheet(
                      distributorModel: distributorModel,
                      onDistributorSelect: (distributor) {
                        if (distributor != null) {
                          distributorModel = distributor;
                          txtSelectDistributorController.text = distributor.name;
                          distributorId = distributor.customerCodes;
                        }
                        txtSelectBeatNameController.text = "";
                        txtOrderBookingController.text = "";
                        beatModal = null;
                      },
                      districtId: districtModel != null ? districtModel!.id.toString() : "",
                    )
                  : txtController == txtSelectBeatNameController
                      ? SelectBeatNameBottomSheet(
                          beatsModal: beatModal,
                          onBeatNameSelect: (beat) {
                            if (beat != null) {
                              beatModal = beat;
                              txtSelectBeatNameController.text = beat.name;

                              getOrderBookingDay();
                            }
                          },
                          customerCode: distributorModel != null ? distributorModel!.customerCodes : "",
                        )
                      : txtController == txtSelectRetailerTypeController
                          ? SelectRetailerTypeBottomSheet(
                              retailerTypeModel: retailerTypeModel,
                              onRetailerTypeSelect: (retailerType) {
                                if (retailerType != null) {
                                  retailerTypeModel = retailerType;
                                  retailerTypeId = retailerType.id.toString();
                                  txtSelectRetailerTypeController.text = retailerType.name;
                                }
                              },
                            )
                          : SelectRetailerCategoryBottomSheet(
                              retailerCategoryModel: retailerCategoryModal,
                              onRetailerCategorySelect: (retailerCategory) {
                                if (retailerCategory != null) {
                                  retailerCategoryModal = retailerCategory;
                                  retailerCategoryId = retailerCategory.id.toString();
                                  txtSelectRetailerCategoryController.text = retailerCategory.category;
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

  void getOrderBookingDay() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["beat_id"] = beatModal == null ? "" : beatModal!.id;
    OrderBookingDayResponse response = await repository.orderBookingDay(input);
    if (response.success) {
      orderBookingDayList = response.data!;
      for (OrderBookingDayModal orderBookingDay in orderBookingDayList) {
        if (orderBookingDay.orderBookingDay1.isEmpty) {
          txtOrderBookingController.text = orderBookingDay.orderBookingDay2;
          orderBookingDayId = orderBookingDay.id.toString();
        } else if (orderBookingDay.orderBookingDay2.isEmpty) {
          txtOrderBookingController.text = orderBookingDay.orderBookingDay1;
          orderBookingDayId = orderBookingDay.id.toString();
        } else {
          txtOrderBookingController.text = orderBookingDay.orderBookingDay1 + ", " + orderBookingDay.orderBookingDay2;
          orderBookingDayId = orderBookingDay.id.toString();
        }
      }
    } else {
      txtOrderBookingController.text = "";
      orderBookingDayId = "";
    }
  }
}
