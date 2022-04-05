import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/order_booking/retailer_detail/retailer_detail_screen.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.transparent,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
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
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        MapsLauncher.launchCoordinates(
                          double.parse(widget.retailer.lat),
                          double.parse(widget.retailer.lng),
                        );
                      },
                      icon: const Image(
                        width: 25,
                        image: AssetImage("assets/location_green.png"),
                      ),
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
                              // maxLines: 3,
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
                    SizedBox(
                      height: 50,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 20,
                          width: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: MColor.colorYellow,
                            borderRadius: BorderRadius.circular(3.5),
                          ),
                          child: const Text(
                            "5",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 50,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image(
                          image: AssetImage(
                            widget.retailer.enrollmentTypeId == "1"
                                ? "assets/key.png"
                                : "assets/hit.png",
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
  }
}
