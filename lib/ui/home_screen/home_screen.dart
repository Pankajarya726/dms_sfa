import 'package:flutter/material.dart';
import 'package:sfa/ui/attendence_home/attendence_home_screen.dart';
import 'package:sfa/utility/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> icons = [
    "assets/home-ic1.png",
    "assets/home-ic2.png",
    "assets/home-ic3.png",
    "assets/home-ic4.png",
    "assets/home-ic5.png",
    "assets/home-ic6.png"
  ];
  List<String> title = [
    "Attendence",
    "Mapping",
    "Enrollment",
    "Task",
    "Orders",
    "Add Visit"
  ];
  List<String> subTitle = [
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40),
              color: colorPrimary,
              height: MediaQuery.of(context).size.height * 0.16,
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/reject.png"),
                ),
                title: const Text(
                  "Smith Johnson",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "  Employee Designation  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: const CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage("assets/edit.png"),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.84,
              width: MediaQuery.of(context).size.width,
              color: colorGrayLite,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                shrinkWrap: false,
                itemCount: 6,
                itemBuilder: (context, int index) {
                  return Card(
                    margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AttendenceHomeScreen()));
                        }
                      },
                      horizontalTitleGap: 20,
                      leading: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: AssetImage(icons[index]),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Text(
                          title[index],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 16),
                        child: Text(
                          subTitle[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      trailing: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 28,
                          color: colorGrayDark,
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
    );
  }
}
