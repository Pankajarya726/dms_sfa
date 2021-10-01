import 'package:flutter/material.dart';
import 'package:sfa/utility/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40),
            color: colorPrimary,
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width,
            child: const ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/edit.png"),
              ),
              title: Text(
                "Smith Johnson",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Employee Designation",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    backgroundColor: Colors.white30),
              ),
              trailing: CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage("assets/edit.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
