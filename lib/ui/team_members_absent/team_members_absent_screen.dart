import 'package:flutter/material.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersAbsentScreen extends StatefulWidget {
  const TeamMembersAbsentScreen({Key? key}) : super(key: key);

  @override
  _TeamMembersAbsentScreenState createState() =>
      _TeamMembersAbsentScreenState();
}

class _TeamMembersAbsentScreenState extends State<TeamMembersAbsentScreen> {
  List<String> names = [
    "Oliver",
    "William",
    "Noah",
    "Peter",
    "Benjamin",
    "George",
  ];
  List<String> absentReason = [
    "Absent due to health Absent due to health Absent due to health",
    "Absent due to urgent Absent due to urgent Absent due to urgent",
    "Absent due to health Absent due to health Absent due to health",
    "Absent due to traffic Absent due to traffic Absent due to traffic",
    "Absent due to urgent Absent due to urgent Absent due to urgent",
    "Absent due to health Absent due to health Absent due to health",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Column(
            children: List.generate(
              absentReason.length,
              (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.fromLTRB(15, 12, 0, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: -8,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    onTap: () {},
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          names[index],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          absentReason[index],
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: colorLightBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: IntrinsicWidth(
                      child: Row(
                        children: [
                          buttonsApproveReject(colorGreen, "Approve"),
                          const SizedBox(
                            width: 10,
                          ),
                          buttonsApproveReject(colorRed, "Reject"),
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              onPressed: () {
                                showAbsentBottomSheet();
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black,
                                size: 27,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showAbsentBottomSheet() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: reportBG,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Oliver",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Reason",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: colorPrimary,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Text(
                        "Lorem Ipsum is simply dummy text of the text printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text. It is a long established fact that a reader will be distracted.It is a long established fact that a reader will be distractedIt is a long established fact that a reader will be distractedIt is a long established fact that a reader will be distracted",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff303030),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: roundedButton(colorGreen, "Approve"),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: roundedButton(colorPrimary, "Reject"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget roundedButton(buttonColor, buttonText) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, 50)),
          backgroundColor: MaterialStateProperty.all(buttonColor),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget buttonsApproveReject(color, text) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          const Size.fromWidth(65),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          BorderSide(color: color),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size.fromRadius(0),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        ),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
