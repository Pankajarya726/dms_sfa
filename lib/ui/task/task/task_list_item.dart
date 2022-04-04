import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/order_booking/retailer_detail/retailer_detail_screen.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class TaskListItems extends StatefulWidget {
  final int index;
  final RetailersModal retailer;
  final String beatId;
  final int orderStatus;

  const TaskListItems({
    Key? key,
    required this.index,
    required this.retailer,
    required this.beatId,
    required this.orderStatus,
  }) : super(key: key);

  @override
  State<TaskListItems> createState() => _TaskListItemsState();
}

class _TaskListItemsState extends State<TaskListItems> {
  @override
  void initState() {
    super.initState();
  }

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RetailerDetailScreen(
                  storeId: widget.retailer.userId,
                ),
              ),
            );
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
                            widget.retailer.outlatName,
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
                      width: 20,
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
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.retailer.primaryAddress,
                              maxLines: 3,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
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
                    Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: MColor.colorYellow,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        "5",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Image(
                        width: 40,
                        height: 40,
                        image: AssetImage(
                          widget.retailer.enrollmentTypeId == "1"
                              ? "assets/retailer.png"
                              : "assets/tele.png",
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
  }
}
