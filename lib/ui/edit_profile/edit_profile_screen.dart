import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sfa/ui/edit_profile/edit_profile_bloc/edit_profie_bloc.dart';
import 'package:sfa/ui/edit_profile/edit_profile_bloc/edit_profile_event.dart';
import 'package:sfa/ui/edit_profile/edit_profile_bloc/edit_profile_state.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController emailId = TextEditingController();
  EditProfileBloc editProfileBloc = EditProfileBloc();
  XFile? image;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (context) => editProfileBloc,
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccessState) {
            loadUserDetails();
            Fluttertoast.showToast(msg: state.response.message);
          }
          if (state is EditProfileFailureState) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        child: WillPopScope(
          onWillPop: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context, true);
            }
            return Future.value(true);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Edit Profile"),
              centerTitle: true,
              backgroundColor: colorPrimary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
            body: BlocBuilder<EditProfileBloc, EditProfileState>(
              builder: (context, state) {
                if (state is EditProfileNetworkState) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is GetUserDetailsFailureState) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is EditProfileLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GetUserDetailsSucessState) {
                  name.text = state.response.data!.name;
                  emailId.text = state.response.data!.email;

                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: image == null
                                  ? state.response.data!.image.isNotEmpty
                                      ? SizedBox(
                                          width: 120,
                                          height: 120,
                                          child: CachedNetworkImage(
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                state.response.data!.image,
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    "assets/3x/placeholder.png"),
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                              color: colorPrimary,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 120,
                                          height: 120,
                                          child: Image.asset(
                                              "assets/3x/placeholder.png",
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover),
                                        )
                                  : SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Image.file(File(image!.path),
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover)),
                            ),
                            Positioned(
                              top: 14,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: InkWell(
                                  onTap: () {
                                    showPicker();
                                  },
                                  child: Container(
                                    color: colorPrimary,
                                    child: Image.asset(
                                      "assets/edit.png",
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                child: TextFormField(
                                  maxLength: 30,
                                  controller: name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                  autocorrect: true,
                                  enableSuggestions: true,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    fillColor: colorGrayLite,
                                    border: InputBorder.none,
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    focusedBorder: UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    name.text = value!;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 50),
                                child: TextFormField(
                                  controller: emailId,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                  autocorrect: true,
                                  enableSuggestions: true,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z.@0-9]")),
                                  ],
                                  decoration: const InputDecoration(
                                    fillColor: colorGrayLite,
                                    border: InputBorder.none,
                                    hintText: "Email ID",
                                    hintStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    focusedBorder: UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    emailId.text = value!;
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (name.text.isNotEmpty &&
                                      emailId.text.isNotEmpty) {
                                    if (EmailValidator.validate(emailId.text) ==
                                        true) {
                                      if (image != null) {
                                        editProfileBloc.add(
                                          EditProfileEvent(
                                              name: name.text,
                                              emailId: emailId.text,
                                              imgFile: File(image!.path)),
                                        );
                                      } else {
                                        editProfileBloc.add(
                                          EditProfileEvent(
                                            name: name.text,
                                            emailId: emailId.text,
                                          ),
                                        );
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Enter valid email format");
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Fields cant't be empty");
                                  }
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(220, 60)),
                                  backgroundColor:
                                      MaterialStateProperty.all(colorPrimary),
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  showPicker() async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return IntrinsicHeight(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: reportBG,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                  child: InkWell(
                    onTap: () {
                      imageFromCamera();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.photo_camera,
                          color: colorPrimary,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                  child: InkWell(
                    onTap: () {
                      imgFromGallery();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.photo,
                          color: colorPrimary,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  imageFromCamera() async {
    XFile? image = await ImagePicker.platform
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      this.image = image;
    });
  }

  imgFromGallery() async {
    XFile? image = await ImagePicker.platform
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      this.image = image;
    });
  }

  loadUserDetails() async {
    var userId = await SharedPrefrence.getStringPreference(SharedPrefrence.id);
    editProfileBloc.add(GetUserDetailsEvent(userId: userId));
  }
}
