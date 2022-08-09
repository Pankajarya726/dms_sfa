import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_details/order_detail_screen.dart';
import 'package:dms/ui/order_booking/retailer_detail/retailer_detail_screen.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/my_location.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

class RetailerListItems extends StatefulWidget {
  final int index;
  final RetailersModal retailer;
  final int orderStatus;

  const RetailerListItems({
    Key? key,
    required this.index,
    required this.retailer,
    required this.orderStatus,
  }) : super(key: key);

  @override
  State<RetailerListItems> createState() => _RetailerListItemsState();
}

class _RetailerListItemsState extends State<RetailerListItems> {
  @override
  void initState() {
    debugPrint("widget.index-->${widget.orderStatus}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        /* color: widget.index == 1 || widget.index == 0
            ? Colors.transparent
            : widget.index == 2
                ? const Color.fromRGBO(197, 181, 0, 1)
                : const Color.fromRGBO(44, 183, 67, 1),*/

        color: widget.retailer.orderStatus == 1 || widget.retailer.orderStatus == 0
            ? Colors.transparent
            : widget.retailer.orderStatus == 2
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
          onTap: () async {
            if (widget.retailer.orderStatus == 3) {
              await databaseHelper.clearDatabase();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailScreen(
                    retailer: widget.retailer,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RetailerDetailScreen(
                    retailer: widget.retailer,
                    orderStatus: widget.retailer.orderStatus,
                  ),
                ),
              );
            }
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              widget.retailer.outlatName,
                              maxLines: 3,
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
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        if (widget.retailer.lat.isEmpty || widget.retailer.lng.isEmpty) {
                          Utility.showToast("Coordinates not found");
                        } else {
                          drawRoute(widget.retailer.lat, widget.retailer.lng);

                          // await MapsLauncher.launchCoordinates(
                          //     double.parse(widget.retailer.lat),
                          //     double.parse(widget.retailer.lng));
                        }
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
                        placeholder: (context, imageProvider) {
                          return const Image(
                            image: AssetImage("assets/placeholder.png"),
                            fit: BoxFit.cover,
                          );
                        },
                        errorWidget: (context, url, error) {
                          return const Image(
                            image: AssetImage("assets/placeholder.png"),
                            fit: BoxFit.cover,
                          );
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
                          padding: const EdgeInsets.only(top: 1, bottom: 1),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                  Image(
                                    image: AssetImage(
                                      widget.retailer.enrollmentTypeId == "1" ? "assets/retailer.png" : "assets/tele.png",
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

  void drawRoute(String lat, String lng) async {
    try {
      LocationData? position = await MyLocation.getCurrentLocation();
      if (position != null) {
        String source = position.latitude.toString() + "," + position.longitude.toString();
        String destination = lat.toString() + "," + lng.toString();
        String url =
            'https://www.google.com/maps/dir/?api=1&origin=$source&destination=$destination&travelmode=driving&dir_action=navigate';
        debugPrint("url---->$url");

        MapLauncher.showDirections(
            destination: Coords(double.parse(lat), double.parse(lng)),
            origin: Coords(position.latitude!, position.longitude!),
            directionsMode: DirectionsMode.driving,
            mapType: MapType.google);

        // await MapsLauncher.launchCoordinates(double.parse(lat), double.parse(lng));

        // if (!await launchUrl(Uri.parse(url))) {
        //   Utility.showToast("Unable to get route...");
        //   // throw 'Could not launch $url';
        // }
        // if (await canLaunch(url)) {
        //   await launch(url);
        // } else {
        //   Utility.showToast("Unable to get route...");
        // }
      } else {
        Utility.showToast("Can not fetch your location, Please try again later");
      }
    } catch (exception) {
      debugPrint("exception--->$exception");
    }
  }
}
