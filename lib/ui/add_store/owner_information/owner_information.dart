import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:dms/model/retailer_form.dart';
import 'package:dms/ui/add_store/model/call_time_slot_response.dart';
import 'package:dms/ui/add_store/model/select_language_response.dart';
import 'package:dms/ui/add_store/product_information/product_information.dart';
import 'package:dms/ui/bottom_sheet_widget/select_callTimeSlot_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_language_bottom_sheet.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../main.dart';

class OwnerInformation extends StatefulWidget {
  final RetailerForm form;

  const OwnerInformation({Key? key, required this.form}) : super(key: key);

  @override
  State<OwnerInformation> createState() => _OwnerInformationState();
}

class _OwnerInformationState extends State<OwnerInformation> {
  File? ownerPhotoFile;
  String? ownerFileName;
  Object whatsAppSmsRadio = "";
  DateTime? dateTimeBirth;
  DateTime? dateTimeAnniversary;
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
  String? callTimeSlotId;
  String? primaryLangId;
  String? primaryLangCode;
  String? secondaryLangId;
  String? secondaryLangCode;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  GlobalKey globalKey = GlobalKey();
  TextEditingController selectedController = TextEditingController();
  CallTimeSlotModel? callTimeSlotModel;
  LanguageModel? languageFirstModel;
  LanguageModel? languageSecondModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => commonBloc,
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.white24,
          title: const Text(
            StringConst.ownerInfo,
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
                  Row(
                    children: [
                      Image.asset("assets/owner.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.ownerName),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtOwnerNameController, StringConst.enterHere),
                  sizedBoxWidget(14.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/phone_call.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.primaryMobile),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtPrimaryMobController, StringConst.enterHere),
                  sizedBoxWidget(14.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/phone_call.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.secondaryMobile),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtSecondaryMobController, StringConst.enterHere),
                  sizedBoxWidget(14.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/phone_call.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.helperMobile),
                    ],
                  ),
                  sizedBoxWidget(12.0, txtSecondaryMobController),
                  textFields(txtHelperMobController, StringConst.enterHere),
                  sizedBoxWidget(14.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/headphones.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.callTimeSlotMand),
                    ],
                  ),
                  sizedBoxWidget(12.0, txtHelperMobController),
                  textFields(
                      txtSelectCallTimeSlotController, StringConst.selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/languages.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.languageFirst),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(
                      txtSelectLangFirstController, StringConst.selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/languages.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.languageSecond),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(
                      txtSelectLangSecondController, StringConst.selectHint),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/whatsapp.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(child: textWidget(StringConst.whatsAppSms)),
                    ],
                  ),
                  sizedBoxWidget(5.0, ""),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocWhatsAppRadioState) {
                        whatsAppSmsRadio = state.whatsAppRadioTag;
                        debugPrint("$whatsAppSmsRadio");
                      }
                      return Row(
                        children: [
                          radioButtonWidget(
                              whatsAppSmsRadio, 1, StringConst.yes),
                          radioButtonWidget(
                              whatsAppSmsRadio, 2, StringConst.no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/pan.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.pan),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  textFields(txtPANController, StringConst.enterHere),
                  sizedBoxWidget(14.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/identity.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.adharNumber),
                    ],
                  ),
                  sizedBoxWidget(12.0, txtPANController),
                  textFields(txtAdharNumberController, StringConst.enterHere),
                  sizedBoxWidget(14.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/cake.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.birthday),
                    ],
                  ),
                  sizedBoxWidget(12.0, txtAdharNumberController),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocBirthdayState) {
                        txtPicDateController.text =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                      }
                      return textFields(
                          txtPicDateController, StringConst.picDate);
                    },
                  ),
                  sizedBoxWidget(20.0, ""),
                  Row(
                    children: [
                      Image.asset("assets/confetti.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.anniversary),
                    ],
                  ),
                  sizedBoxWidget(12.0, ""),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocAnniversaryState) {
                        txtAnniversaryController.text =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                      }
                      return textFields(
                          txtAnniversaryController, StringConst.picDate);
                    },
                  ),
                  sizedBoxWidget(5.0, ""),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxWidget(17.0, ""),
                      Row(
                        children: [
                          Image.asset("assets/gallery.png"),
                          const SizedBox(
                            width: 10,
                          ),
                          textWidget(StringConst.ownerPhoto),
                        ],
                      ),
                      sizedBoxWidget(12.0, ""),
                      BlocBuilder<CommonBloc, CommonBlocStates>(
                        builder: (context, state) {
                          if (state is CommonBlocSelectOwnerImageState) {
                            ownerPhotoFile = state.imageFile;
                          }
                          return InkWell(
                            onTap: () {
                              selectImage();
                            },
                            child: selectImageWidget(),
                          );
                        },
                      ),
                    ],
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
            if (txtOwnerNameController.text.isEmpty) {
              Utility.showToast("Please enter owner name");
            } else if (txtPrimaryMobController.text.isEmpty) {
              Utility.showToast("Please enter primary mobile");
            } else if (txtSelectCallTimeSlotController.text.isEmpty) {
              Utility.showToast("Please select call time slot");
            } else if (txtSelectLangFirstController.text.isEmpty) {
              Utility.showToast("Please select language 1st");
            } else if (whatsAppSmsRadio == "") {
              Utility.showToast(
                  "Please select opt-in for whatsapp message / SMS");
            } else {
              Map<String, dynamic> ownerInfo = HashMap<String, dynamic>();

              widget.form.ownerName = txtOwnerNameController.text.trim();
              widget.form.mobileNumber = txtPrimaryMobController.text.trim();
              widget.form.secondaryMobile =
                  txtSecondaryMobController.text.trim();
              widget.form.helperNumber = txtHelperMobController.text.trim();
              widget.form.callTimeSlotId = callTimeSlotId ?? "";
              widget.form.languageId1 = primaryLangId ?? "";
              widget.form.languageId2 = secondaryLangId ?? "";
              widget.form.isWhatsappSms = whatsAppSmsRadio == 1 ? "1" : "0";
              widget.form.pan = txtPANController.text.trim();
              widget.form.aadhaarNumber = txtAdharNumberController.text.trim();
              widget.form.birthday = txtPicDateController.text.trim();
              widget.form.anniversary = txtAnniversaryController.text.trim();
              widget.form.ownerImage =
                  ownerPhotoFile != null ? ownerPhotoFile!.path : "";

              log("retailer-from---->${widget.form.toMap().toString()}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductInformation(form: widget.form),
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

  Widget sizedBoxWidget(boxHeight, txtController) {
    return SizedBox(
      key: selectedController == txtController ? globalKey : null,
      height: boxHeight,
    );
  }

  Widget textFields(txtController, textHint) {
    return txtController == txtSelectCallTimeSlotController ||
            txtController == txtSelectLangFirstController ||
            txtController == txtSelectLangSecondController
        ? TextFormField(
            onTap: () async {
              FocusScope.of(context).unfocus();
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
              suffixIcon: txtController == txtPicDateController ||
                      txtController == txtAnniversaryController
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
          )
        : txtController == txtPicDateController ||
                txtController == txtAnniversaryController
            ? TextFormField(
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (txtController == txtPicDateController) {
                    dateTimeBirth ??= await NTP.now();
                    dateTimeBirth = await showDatePicker(
                      context: context,
                      initialDate: dateTimeBirth!,
                      firstDate: DateTime(1950),
                      lastDate: await NTP.now(),
                    );
                    if (dateTimeBirth != null) {
                      commonBloc.add(
                          CommonBlocBirthdayEvent(dateTime: dateTimeBirth!));
                    }
                  }
                  if (txtController == txtAnniversaryController) {
                    dateTimeAnniversary ??= await NTP.now();
                    dateTimeAnniversary = await showDatePicker(
                      context: context,
                      initialDate: dateTimeAnniversary!,
                      firstDate: DateTime(1950),
                      lastDate: await NTP.now(),
                    );
                    if (dateTimeAnniversary != null) {
                      commonBloc.add(CommonBlocAnniversaryEvent(
                          dateTime: dateTimeAnniversary!));
                    }
                  }
                },
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.67,
                  color: MColor.backButton,
                ),
                controller: txtController,
                decoration: InputDecoration(
                  suffixIcon: txtController == txtPicDateController ||
                          txtController == txtAnniversaryController
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
              )
            : TextFormField(
                onFieldSubmitted: (value) {
                  selectedController = TextEditingController();
                },
                onTap: () async {
                  selectedController = txtController;
                  await Future.delayed(const Duration(milliseconds: 500));
                  RenderObject? object =
                      globalKey.currentContext!.findRenderObject();
                  object!.showOnScreen();
                },
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
    return GestureDetector(
      onTap: () {
        commonBloc.add(CommonBlocWhatsAppRadioEvent(whatsAppRadioTag: value));
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
                commonBloc
                    .add(CommonBlocWhatsAppRadioEvent(whatsAppRadioTag: value));
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

  Widget selectImageWidget() {
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
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) {
          return txtController == txtSelectLangFirstController
              ? SelectLanguageBottomSheet(
                  languageModel: languageFirstModel,
                  onLanguageSelect: (languageName) {
                    if (languageName != null) {
                      languageFirstModel = languageName;
                      txtSelectLangFirstController.text =
                          languageName.languageName;
                      primaryLangId = languageName.id.toString();
                    }
                  },
                  bottomSheetHeading: "1",
                  previousSelectedLang: txtSelectLangSecondController.text,
                )
              : txtController == txtSelectLangSecondController
                  ? SelectLanguageBottomSheet(
                      languageModel: languageSecondModel,
                      onLanguageSelect: (languageName) {
                        if (languageName != null) {
                          languageSecondModel = languageName;
                          txtSelectLangSecondController.text =
                              languageName.languageName;
                          secondaryLangId = languageName.id.toString();
                        }
                      },
                      bottomSheetHeading: "2",
                      previousSelectedLang: txtSelectLangFirstController.text,
                    )
                  : SelectCallTimeSlotBottomSheet(
                      callTimeSlotModel: callTimeSlotModel,
                      onCallTimeSlotSelect: (callTimeSlot) {
                        if (callTimeSlot != null) {
                          callTimeSlotModel = callTimeSlot;
                          callTimeSlotId = callTimeSlot.id.toString();
                          txtSelectCallTimeSlotController.text =
                              callTimeSlot.from + " to " + callTimeSlot.to;
                        }
                      },
                    );
        });
  }

  void onRefresh() async {
    refreshController.refreshCompleted();
  }
}
