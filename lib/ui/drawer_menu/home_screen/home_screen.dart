import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kf_drawer/kf_drawer.dart';

class HomeScreen extends KFDrawerContent {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// home screen
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(67.0),
          child: AppBar(
            elevation: 3,
            backgroundColor: Colors.white,
            titleSpacing: 8,
            leading: Align(
              child: InkWell(
                onTap: widget.onMenuPressed,
                child: SvgPicture.asset(
                  "assets/menu.svg",
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://cdnaws.sharechat.com/a49913b5-024a-4ecd-9c86-4940a94f53d8-46107328-99c3-41f7-a542-74ce42eca32c_compressed_40.jpg",
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images/3x/placeholder.png"),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(
                  width: 17,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Employee Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 7),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Employee Designation",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
