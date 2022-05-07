import 'dart:collection';
import 'dart:io';
import 'package:dms/model/retailer_form.dart';
import 'package:dms/ui/add_store/model/call_time_slot_response.dart';
import 'package:dms/ui/add_store/model/select_language_response.dart';
import 'package:dms/ui/add_store/owner_information/model/check_mobile_response.dart';
import 'package:dms/ui/add_store/product_information/product_information.dart';
import 'package:dms/ui/bottom_sheet_widget/select_call_time_slot_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/select_language_bottom_sheet.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/ui/custom_widget/input_widget.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../main.dart';

class OwnerInformation extends StatefulWidget {
  final RetailerForm form;
  const OwnerInformation({
    Key? key,
    required this.form,
  }) : super(key: key);

  @override
  State<OwnerInformation> createState() => _OwnerInformationState();
}

class _OwnerInformationState extends State<OwnerInformation> {
  File? ownerPhotoFile;
  String? ownerFileName;
  String whatsAppSmsRadio = "";
  DateTime? dateTimeBirth;
  DateTime? dateTimeAnniversary;
  CommonBloc commonBloc = CommonBloc();
  TextEditingController txtOwnerName = TextEditingController();
  TextEditingController txtPrimaryMobile = TextEditingController();
  TextEditingController txtSecondaryMobile = TextEditingController();
  TextEditingController txtHelperMobile = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtCallTime = TextEditingController();
  TextEditingController txtPrimaryLang = TextEditingController();
  TextEditingController txtSecondaryLang = TextEditingController();
  TextEditingController txtPAN = TextEditingController();
  TextEditingController txtAdhaar = TextEditingController();
  TextEditingController txtBirthday = TextEditingController();
  TextEditingController txtAnniversary = TextEditingController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  GlobalKey globalKeyName = GlobalKey();
  GlobalKey globalKeyPrimMob = GlobalKey();
  GlobalKey globalKeySecMob = GlobalKey();
  GlobalKey globalKeyHelpMob = GlobalKey();
  GlobalKey globalKeyEmail = GlobalKey();
  GlobalKey globalKeyPAN = GlobalKey();
  GlobalKey globalKeyAadhar = GlobalKey();
  CallTimeSlotModel? callTimeSlotModel;
  LanguageModel? primaryLanguage;
  LanguageModel? secondaryLanguage;
  bool mobileAlreadyExist = false;

  @override
  void initState() {
    super.initState();
    restorePrevSession();
  }

  restorePrevSession() {
    ownerPhotoFile =
        widget.form.ownerImage.isEmpty ? null : File(widget.form.ownerImage);
    whatsAppSmsRadio = widget.form.isWhatsappSms;
    txtOwnerName.text = widget.form.ownerName;
    txtPrimaryMobile.text = widget.form.primaryMobile;
    txtSecondaryMobile.text = widget.form.secondaryMobile;
    txtHelperMobile.text = widget.form.helperMobile;
    txtEmail.text = widget.form.email;

    callTimeSlotModel = widget.form.callTimeSlot;
    if (callTimeSlotModel != null) {
      txtCallTime.text =
          callTimeSlotModel!.from + " to " + callTimeSlotModel!.to;
    }

    primaryLanguage = widget.form.primaryLang;
    secondaryLanguage = widget.form.secondaryLang;
    if (primaryLanguage != null) {
      txtPrimaryLang.text = primaryLanguage!.languageName;
    }

    if (secondaryLanguage != null) {
      txtSecondaryLang.text = secondaryLanguage!.languageName;
    }

    txtPAN.text = widget.form.pan;
    txtAdhaar.text = widget.form.aadhaarNumber;
    txtBirthday.text = widget.form.birthday;
    txtAnniversary.text = widget.form.anniversary;
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/owner.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.ownerNameMand),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  OwnerNameEditText(
                    controller: txtOwnerName,
                    hint: StringConst.enterHere,
                    globalKey: globalKeyName,
                    onChange: (String text) {
                      widget.form.ownerName = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/phone_call.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.primaryMobile),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  MobileEditText(
                    hint: StringConst.enterHere,
                    controller: txtPrimaryMobile,
                    globalKey: globalKeyPrimMob,
                    onChange: (text) {
                      if (text.length == 10) {
                        checkMobileNumber();
                      }
                      widget.form.primaryMobile = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/phone_call.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.secondaryMobile),
                    ],
                  ),
                  SizedBox(
                    key: globalKeyPrimMob,
                  ),
                  sizedBoxWidget(12.0),
                  MobileEditText(
                    hint: StringConst.enterHere,
                    controller: txtSecondaryMobile,
                    globalKey: globalKeySecMob,
                    onChange: (text) {
                      if (text == txtPrimaryMobile.text) {
                        Utility.showToast(
                            "Primary and secondary mobile number should not be same");
                      }
                      widget.form.secondaryMobile = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/phone_call.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.helperMobile),
                    ],
                  ),
                  SizedBox(
                    key: globalKeySecMob,
                    height: 12.0,
                  ),
                  MobileEditText(
                    hint: StringConst.enterHere,
                    controller: txtHelperMobile,
                    globalKey: globalKeyHelpMob,
                    onChange: (text) {
                      widget.form.helperMobile = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/gmail.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.email),
                    ],
                  ),
                  SizedBox(
                    key: globalKeyHelpMob,
                    height: 12.0,
                  ),
                  EmailEditText(
                    hint: StringConst.enterHere,
                    controller: txtEmail,
                    globalKey: globalKeyEmail,
                    onChange: (text) {
                      widget.form.email = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/headphones.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.callTimeSlotMand),
                    ],
                  ),
                  SizedBox(
                    key: globalKeyEmail,
                    height: 12.0,
                  ),
                  textFields(txtCallTime, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/languages.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.languageFirst),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  textFields(txtPrimaryLang, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/languages.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.languageSecond),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  textFields(txtSecondaryLang, StringConst.selectHint),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/whatsapp.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.whatsAppSms),
                    ],
                  ),
                  sizedBoxWidget(5.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocWhatsAppRadioState) {
                        whatsAppSmsRadio = state.whatsAppRadioTag;
                        widget.form.isWhatsappSms = state.whatsAppRadioTag;
                        debugPrint(whatsAppSmsRadio);
                      }
                      return Row(
                        children: [
                          radioButtonWidget(
                              whatsAppSmsRadio, "1", StringConst.yes),
                          radioButtonWidget(
                              whatsAppSmsRadio, "2", StringConst.no),
                        ],
                      );
                    },
                  ),
                  sizedBoxWidget(5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/pan.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.pan),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  PANEditText(
                    controller: txtPAN,
                    hint: StringConst.enterHere,
                    globalKey: globalKeyPAN,
                    onChange: (String text) {
                      widget.form.pan = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/identity.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.adharNumber),
                    ],
                  ),
                  SizedBox(
                    key: globalKeyPAN,
                    height: 12.0,
                  ),
                  AadharEditText(
                    controller: txtAdhaar,
                    hint: StringConst.enterHere,
                    globalKey: globalKeyAadhar,
                    onChange: (String text) {
                      widget.form.aadhaarNumber = text;
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/cake.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.birthday),
                    ],
                  ),
                  SizedBox(
                    key: globalKeyAadhar,
                    height: 12.0,
                  ),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocBirthdayState) {
                        txtBirthday.text =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                        widget.form.birthday =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                      }

                      return DateEditText(
                        controller: txtBirthday,
                        hint: StringConst.picDate,
                        name: StringConst.birthday,
                        onChange: (text) {
                          widget.form.birthday = text;
                        },
                      );
                    },
                  ),
                  sizedBoxWidget(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/confetti.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      textWidget(StringConst.anniversary),
                    ],
                  ),
                  sizedBoxWidget(12.0),
                  BlocBuilder<CommonBloc, CommonBlocStates>(
                    builder: (context, state) {
                      if (state is CommonBlocAnniversaryState) {
                        txtAnniversary.text =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                        widget.form.anniversary =
                            DateFormat("yyyy-MM-dd").format(state.dateTime);
                      }
                      return DateEditText(
                        controller: txtAnniversary,
                        hint: StringConst.picDate,
                        name: StringConst.anniversary,
                        onChange: (text) {
                          widget.form.anniversary = text;
                        },
                      );
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxWidget(20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/gallery.png"),
                          const SizedBox(
                            width: 10,
                          ),
                          textWidget(StringConst.ownerPhoto),
                        ],
                      ),
                      sizedBoxWidget(10.0),
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
            Utility.hideKeyboard();
            FocusScope.of(context).unfocus();
            if (txtOwnerName.text.trim().isEmpty) {
              Utility.showToast("Please enter owner name");
            } else if (txtPrimaryMobile.text.isEmpty) {
              Utility.showToast("Please enter primary mobile");
            } else if (txtPrimaryMobile.text == txtSecondaryMobile.text) {
              Utility.showToast(
                  "Primary and secondary mobile number should not be same");
            } else if (txtCallTime.text.isEmpty) {
              Utility.showToast("Please select call time slot");
            } else if (txtPrimaryLang.text.isEmpty) {
              Utility.showToast("Please select language 1st");
            } else if (whatsAppSmsRadio == "") {
              Utility.showToast(
                  "Please select opt-in for whatsapp message / SMS");
            } else if (txtOwnerName.text.length < 3) {
              Utility.showToast(
                  "Owner name should be minimum 3 characters long");
            } else if (txtPrimaryMobile.text.length < 10) {
              Utility.showToast("Please enter valid primary mobile number");
            } else if (widget.form.checkMobileNumber == false) {
              Utility.showToast("Mobile number already exist");
            } else if (txtSecondaryMobile.text.length < 10 &&
                txtSecondaryMobile.text.isNotEmpty) {
              Utility.showToast("Please enter valid secondary mobile number");
            } else if (txtHelperMobile.text.length < 10 &&
                txtHelperMobile.text.isNotEmpty) {
              Utility.showToast("Please enter valid helper mobile number");
            } else if (txtEmail.text.isNotEmpty &&
                !txtEmail.text.contains(RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'))) {
              Utility.showToast("Please enter valid email address");
            } else if (!txtPAN.text
                    .contains(RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}")) &&
                txtPAN.text.isNotEmpty) {
              Utility.showToast("Please enter valid PAN number");
            } else if (!txtAdhaar.text.contains(RegExp('^[2-9]{1}[0-9]{11}')) &&
                txtAdhaar.text.isNotEmpty) {
              Utility.showToast("Please enter valid aadhar number");
            } else {
              widget.form.ownerName = txtOwnerName.text.trim();
              widget.form.primaryMobile = txtPrimaryMobile.text.trim();
              widget.form.secondaryMobile = txtSecondaryMobile.text.trim();
              widget.form.helperMobile = txtHelperMobile.text.trim();
              widget.form.email = txtEmail.text.trim();
              widget.form.callTimeSlot = callTimeSlotModel;
              widget.form.primaryLang = primaryLanguage;
              widget.form.secondaryLang = secondaryLanguage;
              widget.form.isWhatsappSms = whatsAppSmsRadio == "1" ? "1" : "0";
              widget.form.pan = txtPAN.text.trim();
              widget.form.aadhaarNumber = txtAdhaar.text.trim();
              widget.form.birthday = txtBirthday.text.trim();
              widget.form.anniversary = txtAnniversary.text.trim();
              widget.form.ownerImage =
                  ownerPhotoFile != null ? ownerPhotoFile!.path : "";

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductInformation(
                    form: widget.form,
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

  void checkMobileNumber() async {
    Map<String, dynamic> input = HashMap<String, dynamic>();
    input["mobile_number"] = txtPrimaryMobile.text;
    CheckMobileResponse response = await repository.checkMobileNumber(input);
    if (await Network.isConnected()) {
      if (response.success) {
        widget.form.checkMobileNumber = true;
        mobileAlreadyExist = true;
      } else {
        widget.form.checkMobileNumber = false;
        mobileAlreadyExist = false;
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(StringConst.internetCheck);
    }
  }

  Widget sizedBoxWidget(boxHeight) {
    return SizedBox(
      height: boxHeight,
    );
  }

  Widget textFields(txtController, textHint) {
    return TextFormField(
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
    return Flexible(
      child: Text(
        currentText,
        maxLines: 3,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.67,
          fontSize: 17,
          color: Colors.black,
        ),
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
          preferredCameraDevice: CameraDevice.front
          imageQuality: 50,);
      if (image != null) {
        ownerPhotoFile = File(image.path);
        ownerFileName = image.name;
        widget.form.ownerImage = ownerPhotoFile!.path;
        commonBloc.add(CommonBlocSelectImageEvent(imageFile: ownerPhotoFile!));
      }
    } catch (exception) {
      Utility.showToast(
        "Permission denied, go to app settings and allow camera permission",
      );
    }
  }

  void openBottomSheet(BuildContext context, txtController) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) {
          return txtController == txtPrimaryLang
              ? SelectLanguageBottomSheet(
                  languageModel: primaryLanguage,
                  onLanguageSelect: (languageName) {
                    if (languageName != null) {
                      primaryLanguage = languageName;
                      txtPrimaryLang.text = languageName.languageName;
                      widget.form.primaryLang = primaryLanguage;
                    }
                  },
                  bottomSheetHeading: "1",
                  previousSelectedLang: txtSecondaryLang.text,
                )
              : txtController == txtSecondaryLang
                  ? SelectLanguageBottomSheet(
                      languageModel: secondaryLanguage,
                      onLanguageSelect: (languageName) {
                        if (languageName != null) {
                          secondaryLanguage = languageName;
                          txtSecondaryLang.text = languageName.languageName;
                          widget.form.secondaryLang = secondaryLanguage;
                        }
                      },
                      bottomSheetHeading: "2",
                      previousSelectedLang: txtPrimaryLang.text,
                    )
                  : SelectCallTimeSlotBottomSheet(
                      callTimeSlotModel: callTimeSlotModel,
                      onCallTimeSlotSelect: (callTimeSlot) {
                        if (callTimeSlot != null) {
                          callTimeSlotModel = callTimeSlot;
                          txtCallTime.text =
                              callTimeSlot.from + " to " + callTimeSlot.to;
                          widget.form.callTimeSlot = callTimeSlotModel;
                        }
                      },
                    );
        });
  }

  void onRefresh() async {
    refreshController.refreshCompleted();
  }
}
