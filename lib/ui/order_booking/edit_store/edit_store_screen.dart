import 'dart:io';

import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc_events.dart';
import 'package:dms/ui/common_bloc/common_bloc_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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
  CommonBloc commonBloc = CommonBloc();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: const [
          Image(
            width: 30,
            image: AssetImage("assets/get_location.png"),
          ),
          SizedBox(
            width: 10,
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
              BlocProvider(
                create: (context) => commonBloc,
                child: BlocBuilder<CommonBloc, CommonBlocStates>(
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
              ),
              sizedBoxTop(),
              textWidget(orderBookingDay),
              sizedBoxTop(),
              textFields(txtOrderBookingController, day),
              sizedBoxBottom(),
              textWidget(outletName),
              sizedBoxTop(),
              textFields(txtOutletNameController, enterHere),
              sizedBoxBottom(),
              textWidget(ownerName),
              sizedBoxTop(),
              textFields(txtOwnerNameController, enterHere),
              sizedBoxBottom(),
              textWidget(latitude),
              sizedBoxTop(),
              textFields(txtLatitudeController, enterHere),
              sizedBoxBottom(),
              textWidget(longitude),
              sizedBoxTop(),
              textFields(txtLongtitudeController, enterHere),
              sizedBoxBottom(),
              textWidget(address),
              sizedBoxTop(),
              textFields(txtAddressController, enterHere),
              sizedBoxBottom(),
              textWidget(landmark),
              sizedBoxTop(),
              textFields(txtLandmarkController, enterHere),
              sizedBoxBottom(),
              textWidget(pincode),
              sizedBoxTop(),
              textFields(txtPincodeController, enterHere),
              sizedBoxBottom(),
              textWidget(primaryMobile),
              sizedBoxTop(),
              textFields(txtPrimaryMobController, enterHere),
              sizedBoxBottom(),
              textWidget(secondaryMobile),
              sizedBoxTop(),
              textFields(txtSecondaryMobController, enterHere),
              sizedBoxBottom(),
              textWidget(existingRetailer),
              BlocProvider(
                create: (context) => commonBloc,
                child: BlocBuilder<CommonBloc, CommonBlocStates>(
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
              ),
              textWidget(isKRO),
              BlocProvider(
                create: (context) => commonBloc,
                child: BlocBuilder<CommonBloc, CommonBlocStates>(
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
              ),
              sizedBoxBottom(),
              textWidget(gstNo),
              sizedBoxTop(),
              textFields(txtGSTController, enterHere),
              sizedBoxBottom(),
              textWidget(pan),
              sizedBoxTop(),
              textFields(txtPANController, enterHere),
              sizedBoxBottom(),
              textWidget(adharNumber),
              sizedBoxTop(),
              textFields(txtAdharNumberController, enterHere),
              sizedBoxBottom(),
              textWidget(email),
              sizedBoxTop(),
              textFields(txtEmailController, enterHere),
              sizedBoxBottom(),
              textWidget(birthday),
              sizedBoxTop(),
              textFields(txtPicDateController, picDate),
              sizedBoxBottom(),
              textWidget(photo),
              sizedBoxTop(),
              BlocProvider(
                create: (context) => commonBloc,
                child: BlocBuilder<CommonBloc, CommonBlocStates>(
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
    );
  }

  Widget sizedBoxTop() {
    return const SizedBox(
      height: 12,
    );
  }

  Widget sizedBoxBottom() {
    return const SizedBox(
      height: 17,
    );
  }

  Widget textFields(txtController, textHint) {
    return txtController == txtPicDateController
        ? GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: "Open Calendar");
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
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    widthFactor: 1,
                    alignment: Alignment.centerRight,
                    child: Image(
                      width: 22,
                      image: AssetImage("assets/calendar_icon.png"),
                    ),
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
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.67,
              color: MColor.backButton,
            ),
            controller: txtController,
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
}
