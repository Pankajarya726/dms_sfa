import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:sfa/ui/team_member_details/team_members_details.dart';
import 'package:sfa/utility/colors.dart';

class TeamMembersStatusScreen extends StatefulWidget {
  const TeamMembersStatusScreen({Key? key}) : super(key: key);

  @override
  _TeamMembersStatusScreenState createState() =>
      _TeamMembersStatusScreenState();
}

class _TeamMembersStatusScreenState extends State<TeamMembersStatusScreen> {
  bool remainingAttendSwitch = false;
  List<String> names = [
    "Oliver",
    "William",
    "Noah",
    "Peter",
    "Benjamin",
    "George",
  ];
  List<String> status = [
    "Present..",
    "Absent",
    "Absent",
    "Present",
    "Present",
    "Mark attendence",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Show remaining attendence",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 35,
                height: 30,
                child: Switch(
                  value: remainingAttendSwitch,
                  onChanged: (value) {
                    setState(() {
                      remainingAttendSwitch = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          Column(
            children: List.generate(
              status.length,
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TeamMembersDetails()));
                    },
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
                          status[index],
                          style: const TextStyle(
                            color: Color(0xff303030),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
                );
              },
            ),
          ),
        ],
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
