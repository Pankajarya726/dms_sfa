import 'package:flutter/material.dart';
import 'package:sfa/utility/colors.dart';

class TeamMemberAttendenceScreen extends StatefulWidget {
  const TeamMemberAttendenceScreen({Key? key}) : super(key: key);

  @override
  _TeamMemberAttendenceScreenState createState() =>
      _TeamMemberAttendenceScreenState();
}

class _TeamMemberAttendenceScreenState
    extends State<TeamMemberAttendenceScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> names = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    List<String> status = [
      "Present..",
      "Absent",
      "Absent",
      "Present",
      "Present",
      "Mark attendence",
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.74,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 14),
        decoration: const BoxDecoration(
          color: reportBG,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              status.length,
              (index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      padding: const EdgeInsets.fromLTRB(15, 12, 0, 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: -8,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        dense: true,
                        onTap: () {},
                        title: Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
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
                                status[index],
                                style: const TextStyle(
                                  color: Color(0xff303030),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IntrinsicWidth(
                          child: Row(
                            children: [
                              status[index] == "Present"
                                  ? statusAccepted()
                                  : status[index] == "Absent"
                                      ? statusRejected()
                                      : status[index] == "Present.."
                                          ? statusIncompleteHoursButAccepted()
                                          : statusMarkAttendence(),
                              SizedBox(
                                width: 40,
                                child: IconButton(
                                  onPressed: () {},
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
                    ),
                    Positioned(
                      left: 10,
                      child: Container(
                        height: 86,
                        width: 65,
                        decoration: const BoxDecoration(
                          color: colorCalenderDateBG,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Sep",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "20",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget statusAccepted() {
    return SizedBox(
      width: 20,
      child: Image.asset(
        "assets/accept.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget statusRejected() {
    return SizedBox(
      width: 20,
      child: Image.asset(
        "assets/reject.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget statusIncompleteHoursButAccepted() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: colorYellow,
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
        child: Text(
          "Present",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget statusMarkAttendence() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
          width: 35,
          height: 35,
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {},
            child: const Text(
              "P",
              style: TextStyle(
                height: 1.1,
                color: colorGreen,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
          width: 35,
          height: 35,
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {},
            child: const Text(
              "A",
              style: TextStyle(
                height: 1.1,
                color: colorRed,
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }
}
