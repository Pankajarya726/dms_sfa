import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:dms/ui/task/task_details/task_detail_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class TaskListItems extends StatefulWidget {
  final int index;
  final RetailersTaskModal retailer;
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskDetailScreen(
                  storeId: widget.retailer.retailerId,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.retailer.uniqueCode,
                              style: const TextStyle(
                                color: Color(0XFF555555),
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                              ),
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
                          Flexible(
                            flex: 2,
                            child: Text(
                              widget.retailer.outletName,
                              style: const TextStyle(
                                color: Color(0XFF555555),
                                letterSpacing: 0.67,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (widget.retailer.latitude.isEmpty || widget.retailer.longitude.isEmpty) {
                          Utility.showToast("Coordinates not found");
                        }
                        MapsLauncher.launchCoordinates(
                          double.parse(widget.retailer.latitude),
                          double.parse(widget.retailer.longitude),
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
                  mainAxisSize: MainAxisSize.min,
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
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1, bottom: 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.retailer.primaryAddress,
                                  style: const TextStyle(
                                    letterSpacing: 0.67,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.retailer.beatName,
                                      style: const TextStyle(
                                        letterSpacing: 0.67,
                                        color: MColor.backButton,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 20,
                                      width: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: MColor.colorYellow,
                                        borderRadius: BorderRadius.circular(3.5),
                                      ),
                                      child: Text(
                                        widget.retailer.pendingTask,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Image(
                                      image: AssetImage(
                                        widget.retailer.taskType == "HIT"
                                            ? "assets/hit.png"
                                            : widget.retailer.taskType == "ST"
                                                ? "assets/special.png"
                                                : "assets/key.png",
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
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
