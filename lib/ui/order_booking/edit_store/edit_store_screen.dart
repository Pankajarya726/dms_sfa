import 'dart:developer';
import 'dart:io';
import 'package:dms/ui/bottom_sheet_widget/select_beat_name_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_city_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_distributor_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_lang_first_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_lang_second_bottom_sheet.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
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
import 'package:ntp/ntp.dart';
import '../../../main.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({Key? key}) : super(key: key);

  @override
  _EditStoreScreenState createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  Object selectEnrollmentRadio = "";
  Object existingRetailerRadio = "";
  Object isKRORadio = "";
  File? imageFile;
  String fileName = "test.jpg";
  DateTime? dateTime;
  CommonBloc commonBloc = CommonBloc();
  UserLocationBloc userLocationBloc = UserLocationBloc();
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
  TextEditingController txtSelectVisitTimeController = TextEditingController();
  TextEditingController txtSelectLangFirstController = TextEditingController();
  TextEditingController txtSelectLangSecondController = TextEditingController();
  TextEditingController txtSelectRetailerTypeController =
      TextEditingController();
  TextEditingController txtSelectRetailerCategoryController =
      TextEditingController();

  @override
  void initState() {
    txtOutletNameController.text = "Pankaj";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build---->");
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => commonBloc),
        BlocProvider(create: (context) => userLocationBloc),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(enrollmentType),
                sizedBoxWidget(5.0),
                BlocBuilder<CommonBloc, CommonBlocStates>(
                  builder: (context, state) {
                    if (state is CommonBlocEnrollRadioTagState) {
                      selectEnrollmentRadio = state.enrollmentRadioTag;
                      debugPrint("$selectEnrollmentRadio");
                    }
                    return Row(
                      children: [
                        radioButtonWidget(selectEnrollmentRadio, 0, retailer),
                        radioButtonWidget(
                            selectEnrollmentRadio, 1, teleRetailer),
                      ],
                    );
                  },
                ),
                sizedBoxWidget(5.0),
                textWidget(city),
                sizedBoxWidget(12.0),
                textFields(txtSelectCityController, selectHint),
                sizedBoxWidget(17.0),
                textWidget(distributor),
                sizedBoxWidget(12.0),
                textFields(txtSelectDistributorController, selectHint),
                sizedBoxWidget(17.0),
                textWidget(beatNameMandatory),
                sizedBoxWidget(12.0),
                textFields(txtSelectBeatNameController, selectHint),
                sizedBoxWidget(17.0),
                textWidget(orderBookingDay),
                sizedBoxWidget(12.0),
                textFields(txtOrderBookingController, day),
                sizedBoxWidget(17.0),
                textWidget(outletName),
                sizedBoxWidget(12.0),
                textFields(txtOutletNameController, enterHere),
                sizedBoxWidget(17.0),
                textWidget(ownerName),
                sizedBoxWidget(12.0),
                textFields(txtOwnerNameController, enterHere),
                sizedBoxWidget(17.0),
                textWidget(latitude),
                sizedBoxWidget(12.0),
                BlocBuilder<UserLocationBloc, UserLocationStates>(
                  bloc: userLocationBloc,
                  builder: (context, state) {
                    print("state---->$state");

                    if (state is UserLocationInitialState) {
                      userLocationBloc.add(GetUserLocationEvent());
                    }

                    if (state is GetUserLocationState) {
                      txtLatitudeController.text = state.latitude.toString();
                      txtLongtitudeController.text = state.longitude.toString();
                      txtAddressController.text = state.currentAddress;
                      txtPincodeController.text = state.pincode;
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
                sizedBoxWidget(17.0),
                textWidget(primaryMobile),
                sizedBoxWidget(12.0),
                textFields(txtPrimaryMobController, enterHere),
                sizedBoxWidget(17.0),
                textWidget(secondaryMobile),
                sizedBoxWidget(12.0),
                textFields(txtSecondaryMobController, enterHere),
                sizedBoxWidget(17.0),
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
                        radioButtonWidget(existingRetailerRadio, 2, yes),
                        radioButtonWidget(existingRetailerRadio, 3, no),
                      ],
                    );
                  },
                ),
                sizedBoxWidget(5.0),
                textWidget(visitTime),
                sizedBoxWidget(12.0),
                textFields(txtSelectVisitTimeController, selectHint),
                sizedBoxWidget(17.0),
                textWidget(languageFirst),
                sizedBoxWidget(12.0),
                textFields(txtSelectLangFirstController, selectHint),
                sizedBoxWidget(17.0),
                textWidget(languageSecond),
                sizedBoxWidget(12.0),
                textFields(txtSelectLangSecondController, selectHint),
                sizedBoxWidget(17.0),
                textWidget(retailerType),
                sizedBoxWidget(12.0),
                textFields(txtSelectRetailerTypeController, selectHint),
                sizedBoxWidget(17.0),
                textWidget(retailerCategory),
                sizedBoxWidget(12.0),
                textFields(txtSelectRetailerCategoryController, selectHint),
                sizedBoxWidget(17.0),
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
                        radioButtonWidget(isKRORadio, 4, yes),
                        radioButtonWidget(isKRORadio, 5, no),
                      ],
                    );
                  },
                ),
                sizedBoxWidget(5.0),
                textWidget(gstNo),
                sizedBoxWidget(12.0),
                textFields(txtGSTController, enterHere),
                sizedBoxWidget(17.0),
                textWidget(pan),
                sizedBoxWidget(12.0),
                textFields(txtPANController, enterHere),
                sizedBoxWidget(17.0),
                textWidget(adharNumber),
                sizedBoxWidget(12.0),
                textFields(txtAdharNumberController, enterHere),
                sizedBoxWidget(17.0),
                textWidget(email),
                sizedBoxWidget(12.0),
                textFields(txtEmailController, enterHere),
                sizedBoxWidget(17.0),
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
                sizedBoxWidget(17.0),
                textWidget(photo),
                sizedBoxWidget(12.0),
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
                                  image: const AssetImage(
                                      "assets/camera_icon.png"),
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
                ),
              ],
            ),
          ),
        ),
        bottomSheet: MaterialButton(
          height: 50,
          minWidth: MediaQuery.of(context).size.width,
          color: MColor.colorSecondary,
          textColor: Colors.white,
          onPressed: () async {},
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
            txtController == txtSelectVisitTimeController ||
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
                    txtController == txtGSTController ||
                    txtController == txtPANController ||
                    txtController == txtAdharNumberController
                ? TextInputType.number
                : TextInputType.text,
            controller: txtController,
            enabled: txtController == txtLatitudeController ||
                    txtController == txtLongtitudeController ||
                    txtController == txtPincodeController
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) {},
            onFieldSubmitted: (v) {
              print("v---->$v");
            },
            onSaved: (value) {
              log(value.toString());
              txtAddressController.text = value!;
            },
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
      if (value == 0 || value == 1) {
        commonBloc
            .add(CommonBlocEnrollTypeRadioEvent(enrollmentRadioTag: value));
      }
      if (value == 2 || value == 3) {
        commonBloc.add(CommonBlocRetailerRadioEvent(retailerRadioTag: value));
      }
      if (value == 4 || value == 5) {
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

  void selectImage() async {
    XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 512,
        maxWidth: 512,
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      imageFile = File(image.path);
      fileName = image.name;
      commonBloc.add(CommonBlocSelectImageEvent(imageFile: imageFile!));
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
                  onCitySelect: (city) {
                    txtSelectCityController.text = city;
                  },
                )
              : txtController == txtSelectDistributorController
                  ? SelectDistributorBottomSheet(
                      selectedDistributorName:
                          txtSelectDistributorController.text.isEmpty
                              ? ""
                              : txtSelectDistributorController.text,
                      onDistributorSelect: (distributor) {
                        txtSelectDistributorController.text = distributor;
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
                          },
                        )
                      : txtController == txtSelectLangFirstController
                          ? SelectLangFirstBottomSheet(
                              selectedLangFirstName:
                                  txtSelectLangFirstController.text.isEmpty
                                      ? ""
                                      : txtSelectLangFirstController.text,
                              onLangFirstSelect: (languageName) {
                                txtSelectLangFirstController.text =
                                    languageName;
                              },
                            )
                          : SelectLangSecondBottomSheet(
                              selectedLangSecondName:
                                  txtSelectLangSecondController.text.isEmpty
                                      ? ""
                                      : txtSelectLangSecondController.text,
                              onLangSecondSelect: (languageName) {
                                txtSelectLangSecondController.text =
                                    languageName;
                              },
                            );
        });
  }
}
