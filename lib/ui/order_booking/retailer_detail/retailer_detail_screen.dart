import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/last_visit_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/no_order_reason_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/task_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/tele_caller_status_bottm_sheet.dart';
import 'package:dms/ui/order_booking/order_booking_list/order_booking_list_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RetailerDetailScreen extends StatefulWidget {
  const RetailerDetailScreen({Key? key}) : super(key: key);

  @override
  _RetailerDetailScreenState createState() => _RetailerDetailScreenState();
}

class _RetailerDetailScreenState extends State<RetailerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      backgroundColor: const Color(0xffF7F7F7),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
              delegate: SliverChildListDelegate([
                DetailGritItem(
                  value: DateFormat("dd-MM-yyyy").format(DateTime.now()),
                  image: "assets/store.png",
                  name: "Last visit",
                  type: 1,
                ),
                const DetailGritItem(
                  value: "3",
                  image: "assets/task.png",
                  name: "Task",
                  type: 2,
                ),
                const DetailGritItem(
                  value: "No Order",
                  image: "assets/phone.png",
                  name: "TC Status",
                  type: 3,
                ),
                const DetailGritItem(
                  value: "Potential",
                  image: "assets/experience.png",
                  name: "₹5,000",
                  type: 4,
                ),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2.6, mainAxisSpacing: 15, crossAxisSpacing: 0)),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 10, bottom: 0, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Store Info",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditStoreScreen()));
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 13,
                      icon: Container(
                        height: 25,
                        width: 25,
                        decoration:
                            const BoxDecoration(color: MColor.colorSecondary, borderRadius: BorderRadius.all(Radius.circular(15))),
                        child: const Center(
                            child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        )),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(237, 237, 237, 0.25),
                    blurRadius: 10,
                  )
                ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: RetailerDetailItem(
                            value: "Rahul Shrivastav",
                            image: "assets/user.png",
                            name: "Owner Name",
                            type: 1,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: const Color(0xffC5C5C5),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: RetailerDetailItem(
                            value: "Friday",
                            image: "assets/telephone.png",
                            name: "Calling Day",
                            type: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: RetailerDetailItem(
                            value: "9450237542",
                            image: "assets/phone_call.png",
                            name: "Primary No.",
                            type: 1,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Color(0xffC5C5C5),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: RetailerDetailItem(
                            value: "7801365498",
                            image: "assets/phone_call.png",
                            name: "Secondary No.",
                            type: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Image(
                            image: AssetImage("assets/map.png"),
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Address",
                                style: TextStyle(color: Color(0xff303030), fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: const Text(
                                  "Major District Rd, depalpur road | near by payal kirana store",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 10, bottom: 0, top: 10),
              child: Text(
                "Remark",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 10, bottom: 0, top: 5),
              child: TextFormField(
                maxLines: 5,
                minLines: 3,
                style: const TextStyle(fontSize: 16, color: Color(0xff555555)),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide.none)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 10, bottom: 0, top: 10),
              child: Text(
                "Order History",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 10, bottom: 0, top: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(237, 237, 237, 0.25),
                    blurRadius: 10,
                  )
                ]),
                child: Column(
                  children: List.generate(
                      4,
                      (index) => Material(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: bottomSheetShape,
                                    builder: (context) =>
                                        const OrderHistoryBottomSheet());
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                height: 50,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffC5C5C5),
                                            width: 0.5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date: ${DateFormat("dd-MM-yyyy").format(DateTime.now())}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xff555555),
                                        letterSpacing: 0.67,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Text(
                                      "Value: ₹7,200",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xff555555),
                                        letterSpacing: 0.67,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]))
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            MaterialButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: bottomSheetShape,
                    isScrollControlled: true,
                    builder: (context) => const NoOrderReasonSheet());
              },
              shape: const RoundedRectangleBorder(),
              child: const Text(
                "NO ORDER",
                style: TextStyle(color: Color(0xffFFFFFF), fontSize: 20, letterSpacing: 0.72),
              ),
              color: const Color(0xff3D8FFF),
              height: 50,
              elevation: 0,
              minWidth: MediaQuery.of(context).size.width / 2,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderBookingListScreen()));
              },
              shape: const RoundedRectangleBorder(),
              child: const Text(
                "ORDER",
                style: TextStyle(color: Color(0xffFFFFFF), fontSize: 20, letterSpacing: 0.72),
              ),
              color: MColor.colorSecondary,
              height: 50,
              elevation: 0,
              minWidth: MediaQuery.of(context).size.width / 2,
            ),
          ],
        ),
      ),
    );
  }

  _appBar(height) => PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, height + 60),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 50,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.home_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                color: MColor.colorPrimary,
                height: height + 20,
                width: MediaQuery.of(context).size.width,
              ),
            ),

            Container(), // Required some widget in between to float AppBar

            Positioned(
              // To take AppBar Size only
              top: 60.0,
              left: 50.0,
              right: 50.0,
              child: AppBar(
                  elevation: 5,
                  toolbarHeight: 60,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.white,
                  primary: false,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          imageUrl: Constants.image,
                          imageBuilder: (context, imageProvider) {
                            return Image(
                              image: imageProvider,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            );
                          },
                          errorWidget: (context, url, error) => Image.asset("assets/placeholder.png"),
                          placeholder: (context, url) => Image.asset("assets/placeholder.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Constants.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            Constants.designation,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      );
}

class DetailGritItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;

  const DetailGritItem({Key? key, required this.image, required this.name, required this.value, required this.type}) : super(key: key);

  @override
  _DetailGritItemState createState() => _DetailGritItemState();
}

class _DetailGritItemState extends State<DetailGritItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.type == 1) {
          showModalBottomSheet(context: context, shape: bottomSheetShape, builder: (context) => LastVisitBottomSheet());
        }
        if (widget.type == 2) {
          showModalBottomSheet(
              context: context, isScrollControlled: true, shape: bottomSheetShape, builder: (context) => TaskBottomSheet());
        }
        if (widget.type == 3) {
          showModalBottomSheet(
              context: context, isScrollControlled: true, shape: bottomSheetShape, builder: (context) => TeleCallerStatusSheet());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(237, 237, 237, 0.25),
            blurRadius: 10,
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(
                widget.image,
              ),
              width: 35,
              height: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(color: Color(0xff303030), fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.value,
                  style: const TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RetailerDetailItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;

  const RetailerDetailItem({Key? key, required this.image, required this.name, required this.value, required this.type})
      : super(key: key);

  @override
  _RetailerDetailItemState createState() => _RetailerDetailItemState();
}

class _RetailerDetailItemState extends State<RetailerDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(
              widget.image,
            ),
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(color: Color(0xff303030), fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.29,
                child: Text(
                  widget.value,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
