import 'dart:io';

import 'package:dms/main.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:image_picker/image_picker.dart';

class StartDayScreen extends StatefulWidget {
  const StartDayScreen({Key? key}) : super(key: key);

  @override
  _StartDayScreenState createState() => _StartDayScreenState();
}

class _StartDayScreenState extends State<StartDayScreen> {
  List<String> primaryTags = ["Retailing", "Joint Working", "Official Meeting", "Dealer Meeting", "Leave", "Holiday"];
  Map<String, List<String>> secondaryTags = {
    "Retailing": [
      "Vijay nagar",
      "Palasiya",
      "Regel square",
    ],
    "Joint Working": ["Joint Working1", "Joint Working2", "Joint Working3"],
    "Official Meeting": ["Official Meeting1", "Official Meeting2", "Official Meeting3"],
    "Dealer Meeting": ["Dealer Meeting1", "Dealer Meeting2", "Dealer Meeting3"],
    "Leave": ["seek leave", "urgent leave", "planed leave"],
    "Holiday": ["National Holiday", "Local holiday"]
  };

  String selectedPrimaryTag = "Retailing";
  String selectedSecondaryTag = "";
  String address = "Akshya Nagar 1st Block 1st Cross, Rammurthy nagar, Bangalore-560016";
  bool isMeeting = false;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          // splashRadius: 12,
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          startMyDay,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2HUqu332IlG8Z6i_A2FbOreYLb59nphdTdA&usqp=CAU"),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    primaryTag,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Tags(
                    itemCount: primaryTags.length,
                    alignment: WrapAlignment.start,
                    itemBuilder: (index) {
                      return ItemTags(
                        singleItem: true,
                        onPressed: (item) {
                          selectedPrimaryTag = item.title!;
                          setState(() {});
                        },
                        active: selectedPrimaryTag == primaryTags[index] ? true : false,
                        title: primaryTags[index],
                        textActiveColor: Colors.black,
                        textColor: const Color(0xff555555),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 16),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        index: index,
                        border: Border.all(color: MColor.colorPrimary),
                        activeColor: const Color(0xFFFFC9CC),
                        color: const Color(0xffFAFAFA),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    secondaryTag,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  selectedPrimaryTag == primaryTags[0]
                      ? Container()
                      : Tags(
                          itemCount: secondaryTags[selectedPrimaryTag]!.length,
                          alignment: WrapAlignment.start,
                          itemBuilder: (index) {
                            return ItemTags(
                              singleItem: true,
                              onPressed: (item) {
                                selectedSecondaryTag = item.title!;
                                setState(() {});
                              },
                              active: selectedSecondaryTag == secondaryTags[selectedPrimaryTag]![index] ? true : false,
                              title: secondaryTags[selectedPrimaryTag]![index],
                              textActiveColor: Colors.black,
                              textColor: const Color(0xff555555),
                              elevation: 0,
                              textStyle: const TextStyle(fontSize: 16),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              index: index,
                              border: Border.all(color: MColor.colorPrimary),
                              activeColor: const Color(0xFFFFC9CC),
                              color: const Color(0xffFAFAFA),
                            );
                          },
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    remark,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF2F2F2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
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
                          address,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  isMeeting = true;
                                  setState(() {});
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isMeeting
                                        ? const Color.fromRGBO(255, 201, 204, 0.5)
                                        : const Color.fromRGBO(196, 196, 196, 0.5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color:
                                          isMeeting ? const Color.fromRGBO(255, 201, 204, 1) : const Color.fromRGBO(196, 196, 196, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Center(child: Text("Yes")),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  isMeeting = false;
                                  setState(() {});
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
                                      color:
                                          isMeeting ? const Color.fromRGBO(196, 196, 196, 1) : const Color.fromRGBO(255, 201, 204, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Center(child: Text("No")),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            selfie,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              selectImage();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(color: const Color.fromRGBO(85, 85, 85, 1), width: 1)),
                              child: imageFile == null
                                  ? Center(
                                      child: Image(
                                        image: const AssetImage("assets/camera_icon.png"),
                                        width: MediaQuery.of(context).size.width / 6,
                                        height: MediaQuery.of(context).size.width / 6,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image(
                                        image: FileImage(imageFile!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: MaterialButton(
        height: 50,
        minWidth: MediaQuery.of(context).size.width,
        color: MColor.colorSecondary,
        textColor: Colors.white,
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              letsBegin,
            ),
            Icon(Icons.arrow_forward_outlined)
          ],
        ),
      ),
    );
  }

  void selectImage() async {
    XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 512, maxWidth: 512, preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      imageFile = File(image.path);
      setState(() {});
    }
  }
}
