import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/model/retaileres_response.dart';
import 'package:dms/ui/order_booking/retailer_detail/retailer_detail_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class RetailerListItems extends StatefulWidget {
  final int index;
  final Retailers retailer;

  const RetailerListItems({Key? key, required this.index, required this.retailer}) : super(key: key);

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
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RetailerDetailScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            widget.retailer.uniqueCode,
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
                            widget.retailer.outletName,
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
                      child: CachedNetworkImage(
                        imageUrl: widget.retailer.outletPicture,
                        height: 50,
                        width: 50,
                        imageBuilder: (context, imageProvider) {
                          return Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Icon(Icons.error);
                        },
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
                              widget.retailer.primaryAddress,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.retailer.beatName,
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
                    // Container(
                    //   height: 50,
                    //   padding: const EdgeInsets.symmetric(vertical: 5),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Container(
                    //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    //         decoration: BoxDecoration(
                    //           color: const Color(0XFFDAA520),
                    //           borderRadius: BorderRadius.circular(2),
                    //         ),
                    //         child: Align(
                    //           child: Text(
                    //             widget.retailer.priority,
                    //             style: const TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w500,
                    //               letterSpacing: 0.67,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
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
