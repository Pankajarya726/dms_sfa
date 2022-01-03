import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class RetailerListItems extends StatelessWidget {
  RetailerListItems({Key? key}) : super(key: key);

  List<String> bidName = [
    "AK Store",
    "Namkeen Store",
    "Muffins Store",
    "AK Store",
    "Namkeen Store",
  ];
  List<String> bidImages = [];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(5),
      itemCount: bidName.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 5,
        );
      },
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Text(
                                "478956",
                                style: TextStyle(
                                  color: Color(0XFF555555),
                                  letterSpacing: 0.67,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 1,
                                height: 12,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                bidName[index],
                                style: const TextStyle(
                                  color: Color(0XFF555555),
                                  letterSpacing: 0.67,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Image(
                          width: 25,
                          image: AssetImage("assets/location_green.png"),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: const Image(
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://learn.g2.com/hubfs/Stock%20images/Digital%20image%20of%20globe%20with%20conceptual%20icons.%20Globalization%20concept.%20Elements%20of%20this%20image%20are%20furnished%20by%20NASA.jpeg"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "1502, Oldsmobile Bravada",
                                  style: TextStyle(
                                    letterSpacing: 0.67,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Palasiya",
                                  style: TextStyle(
                                    letterSpacing: 0.67,
                                    color: MColor.backButton,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0XFFDAA520),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Align(
                                  child: Text(
                                    "POB",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.67,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
