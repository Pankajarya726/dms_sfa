import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class OrderBookingListItems extends StatefulWidget {
  final int index;
  final Flavours flavours;

  const OrderBookingListItems(
      {Key? key, required this.index, required this.flavours})
      : super(key: key);

  @override
  State<OrderBookingListItems> createState() => _OrderBookingListItemsState();
}

class _OrderBookingListItemsState extends State<OrderBookingListItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: () {},
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: const Image(
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://d29qfl7sjqf9f5.cloudfront.net/uploads/image/image/503094/photo.jpg"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.only(top: 1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.flavours.flavourName,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: MColor.backButton,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.flavours.mrp,
                                  style: const TextStyle(
                                    letterSpacing: 0.67,
                                    color: MColor.backButton,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.flavours.ptr,
                                  style: const TextStyle(
                                    letterSpacing: 0.67,
                                    color: MColor.backButton,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textFields("BOX"),
                                textFields("MOQ"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textFields(textLabel) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.red,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              textLabel,
              style: const TextStyle(
                color: MColor.colorPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.67,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: MColor.backButton,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class Flavours {
  String flavourName;
  String mrp;
  String ptr;

  String image;

  Flavours({
    required this.flavourName,
    required this.mrp,
    required this.ptr,
    required this.image,
  });
}
