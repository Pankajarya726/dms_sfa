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
  int currentBottomTabIndex = 0;

  List<String> itemLabels = [
    "Team Perform",
    "Market Visit",
    "Task",
    "Enrollment",
    "Order Booking",
    "Dealer Info",
  ];

  List<String> itemIcons = [
    "assets/team_perform.png",
    "assets/market_visit.png",
    "assets/task.png",
    "assets/enrollment.png",
    "assets/order_booking.png",
    "assets/dealer_info.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        toolbarHeight: 75,
        elevation: 3,
        shadowColor: Colors.black26,
        centerTitle: false,
        leading: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: widget.onMenuPressed,
            child: SizedBox(
              child: Align(
                child: SvgPicture.asset(
                  "assets/menu.svg",
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                imageUrl:
                    "https://cdnaws.sharechat.com/a49913b5-024a-4ecd-9c86-4940a94f53d8-46107328-99c3-41f7-a542-74ce42eca32c_compressed_40.jpg",
                errorWidget: (context, url, error) => Image.asset("assets/images/3x/placeholder.png"),
                placeholder: (context, url) => const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Smith Johnson",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3505A).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    "Employee Designation",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: Colors.grey[600],
          currentIndex: currentBottomTabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: ontemTaped,
          elevation: 0,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: SvgPicture.asset(
                  "assets/tutorials.svg",
                  height: 25,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
              label: "Tutorials",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: SvgPicture.asset(
                  "assets/product.svg",
                  height: 25,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
              label: "Product",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: SvgPicture.asset(
                  "assets/performance.svg",
                  height: 25,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
              label: "Performance",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: SvgPicture.asset(
                  "assets/plan.svg",
                  height: 25,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
              label: "Plan",
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        children: List.generate(itemLabels.length, (index) {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 8,
                  color: Color.fromRGBO(181, 181, 181, 0.25),
                )
              ],
            ),
            child: Material(
              color: Colors.white,
              // elevation: 3,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        itemIcons[index],
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.width / 8,
                      ),
                      Text(
                        itemLabels[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 0.67,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void ontemTaped(int index) {
    setState(() {
      currentBottomTabIndex = index;
    });
  }
}
