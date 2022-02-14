import 'dart:io';
import 'package:dms/ui/bottom_sheet_widget/select_callTimeSlot_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_language_bottom_sheet.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../main.dart';

class OwnerInformation extends StatefulWidget {
  const OwnerInformation({Key? key}) : super(key: key);

  @override
  State<OwnerInformation> createState() => _OwnerInformationState();
}

class _OwnerInformationState extends State<OwnerInformation> {
  File? ownerPhotoFile;
  String? ownerFileName;
  Object whatsAppSmsRadio = "";
  DateTime? dateTime;
  CommonBloc commonBloc = CommonBloc();
  TextEditingController txtOwnerNameController = TextEditingController();
  TextEditingController txtPrimaryMobController = TextEditingController();
  TextEditingController txtSecondaryMobController = TextEditingController();
  TextEditingController txtHelperMobController = TextEditingController();
  TextEditingController txtSelectCallTimeSlotController =
      TextEditingController();
  TextEditingController txtSelectLangFirstController = TextEditingController();
  TextEditingController txtSelectLangSecondController = TextEditingController();
  TextEditingController txtPANController = TextEditingController();
  TextEditingController txtAdharNumberController = TextEditingController();
  TextEditingController txtPicDateController = TextEditingController();
  TextEditingController txtAnniversaryController = TextEditingController();
  int? callTimeSlotId;
  int? primaryLangId;
  String? primaryLangCode;
  int? secondaryLangId;
  String? secondaryLangCode;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommonBloc(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.white24,
          title: const Text(
            ownerInfo,
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
                  textWidget(ownerName),
                  sizedBoxWidget(12.0),
                  textFields(txtOwnerNameController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(primaryMobile),
                  sizedBoxWidget(12.0),
                  textFields(txtPrimaryMobController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(secondaryMobile),
                  sizedBoxWidget(12.0),
                  textFields(txtSecondaryMobController, enterHere),
                  sizedBoxWidget(20.0),
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
                  textWidget(whatsAppSms),
                  sizedBoxWidget(5.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocWhatsAppRadioState) {
                        whatsAppSmsRadio = state.whatsAppRadioTag;
                        debugPrint("");
                      }
                      return Row(
                        children: [
                          radioButtonWidget(whatsAppSmsRadio, 1, yes),
                          radioButtonWidget(whatsAppSmsRadio, 2, no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0),
                  textWidget(pan),
                  sizedBoxWidget(12.0),
                  textFields(txtPANController, enterHere),
                  sizedBoxWidget(20.0),
                  textWidget(adharNumber),
                  sizedBoxWidget(12.0),
                  textFields(txtAdharNumberController, enterHere),
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
                  textWidget(anniversary),
                  sizedBoxWidget(12.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocSelectDateState) {
                        txtAnniversaryController.text =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                      }
                      return textFields(txtAnniversaryController, picDate);
                    },
                  ),
                  sizedBoxWidget(5.0),
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
                              selectImage();
                            },
                            child: selectImageWidget(ownerName),
                          );
                        },
                      ),
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
            if (txtOwnerNameController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter owner name");
            } else if (txtPrimaryMobController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please enter primary mobile");
            } else if (txtSelectCallTimeSlotController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select call time slot");
            } else if (txtSelectLangFirstController.text.isEmpty) {
              Fluttertoast.showToast(msg: "Please select language 1st");
            } else if (whatsAppSmsRadio == "") {
              Fluttertoast.showToast(
                  msg: "Please select opt-in for whatsapp message / SMS");
            } else {
              Fluttertoast.showToast(msg: "Store added successful");
            }
            // String userId = await SharedPreference.getStringPreference(
            //     SharedPreference.userId);
            debugPrint("edit store userId ");
            debugPrint("edit store enrollmentTypeId ");
            debugPrint("edit store cityId ");
            debugPrint("edit store distributorId ");
            debugPrint("edit store beatId ");
            debugPrint("edit store orderBookingDayId ");
            debugPrint("edit store ownerName ${txtOwnerNameController.text}");
            debugPrint(
                "edit store primaryMobile ${txtPrimaryMobController.text}");
            debugPrint(
                "edit store secondaryMobile ${txtSecondaryMobController.text}");
            debugPrint("edit store callTimeSlotId ");
            debugPrint("edit store primaryLangId ");
            debugPrint("edit store secondaryLangId ");
            debugPrint("edit store retailerTypeId ");
            debugPrint("edit store retailerCategoryId ");
            if (whatsAppSmsRadio == yes) {
              debugPrint("edit store whatsAppMessage ");
            } else {
              debugPrint("edit store whatsAppMessage ");
            }
            debugPrint("edit store panNo ${txtPANController.text}");
            debugPrint("edit store aadhar ${txtAdharNumberController.text}");
            debugPrint("edit store birthday ${txtPicDateController.text}");
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
            txtController == txtAnniversaryController ||
            txtController == txtSelectCallTimeSlotController ||
            txtController == txtSelectLangFirstController ||
            txtController == txtSelectLangSecondController
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
            keyboardType: txtController == txtPrimaryMobController ||
                    txtController == txtSecondaryMobController ||
                    txtController == txtHelperMobController ||
                    txtController == txtAdharNumberController
                ? TextInputType.number
                : TextInputType.text,
            controller: txtController,
            maxLength: txtController == txtPrimaryMobController ||
                    txtController == txtSecondaryMobController ||
                    txtController == txtHelperMobController
                ? 10
                : null,
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
      child: ownerPhotoFile == null
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

  void selectImage() async {
    try {
      XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxHeight: 512,
          maxWidth: 512,
          preferredCameraDevice: CameraDevice.front);
      if (image != null) {
        ownerPhotoFile = File(image.path);
        ownerFileName = image.name;
        commonBloc.add(CommonBlocSelectImageEvent(imageFile: ownerPhotoFile!));
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
          return txtController == txtSelectLangFirstController
              ? SelectLanguageBottomSheet(
                  selectedLanguageName:
                      txtSelectLangFirstController.text.isEmpty
                          ? ""
                          : txtSelectLangFirstController.text,
                  onLanguageSelect: (languageName, id) {
                    txtSelectLangFirstController.text = languageName;
                    if (id != null) {
                      primaryLangId = id;
                    }
                  },
                  bottomSheetHeading: "1",
                  previousSelectedLang: txtSelectLangSecondController.text,
                )
              : txtController == txtSelectLangSecondController
                  ? SelectLanguageBottomSheet(
                      selectedLanguageName:
                          txtSelectLangSecondController.text.isEmpty
                              ? ""
                              : txtSelectLangSecondController.text,
                      onLanguageSelect: (languageName, id) {
                        txtSelectLangSecondController.text = languageName;
                        if (id != null) {
                          secondaryLangId = id;
                        }
                      },
                      bottomSheetHeading: "2",
                      previousSelectedLang: txtSelectLangFirstController.text,
                    )
                  : SelectCallTimeSlotBottomSheet(
                      selectedCallTimeSlotName:
                          txtSelectCallTimeSlotController.text.isEmpty
                              ? ""
                              : txtSelectCallTimeSlotController.text,
                      onCallTimeSlotSelect: (callTimeSlot, id) {
                        txtSelectCallTimeSlotController.text = callTimeSlot;
                        if (id != null) {
                          callTimeSlotId = id;
                        }
                      },
                    );
        });
  }

  void onRefresh() async {
    refreshController.refreshCompleted();
  }
}
