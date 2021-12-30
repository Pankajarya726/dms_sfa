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
    return ListView.builder(
      itemCount: bidName.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 8,
                color: Color.fromRGBO(181, 181, 181, 0.25),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Text("478956"),
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
                              Text(bidName[index]),
                            ],
                          ),
                        ),
                        const Icon(Icons.location_pin)
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("1502, Oldsmobile Bravada"),
                              Text("Palasiya"),
                            ],
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 25,
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
