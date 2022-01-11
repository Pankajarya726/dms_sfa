import 'package:dms/ui/order_booking/retailer_detail/retailer_detail_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class RetailerListItems extends StatefulWidget {
  final int index;
  final Retailer retailer;

  const RetailerListItems(
      {Key? key, required this.index, required this.retailer})
      : super(key: key);

  @override
  State<RetailerListItems> createState() => _RetailerListItemsState();
}

class _RetailerListItemsState extends State<RetailerListItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: widget.index == 0
            ? Colors.transparent
            : widget.index == 1
                ? const Color.fromRGBO(197, 181, 0, 1)
                : const Color.fromRGBO(44, 183, 67, 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => RetailerDetailScreen()));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            widget.retailer.code,
                            style: const TextStyle(
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
                            widget.retailer.storeName,
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
                          children: [
                            Text(
                              widget.retailer.address,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.retailer.locationName,
                              style: const TextStyle(
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
                            child: Align(
                              child: Text(
                                widget.retailer.priority,
                                style: const TextStyle(
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
  }
}

class Retailer {
  String id;
  String code;
  String storeName;
  String address;
  String locationName;
  String locationId;
  String image;
  String priority;

  Retailer(
      {required this.id,
      required this.code,
      required this.storeName,
      required this.address,
      required this.locationName,
      required this.locationId,
      required this.image,
      required this.priority});
}
