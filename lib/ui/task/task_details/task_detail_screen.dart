import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/escalated_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/last_escalation_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/task_details_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/task_history_bottom_sheet.dart';
import 'package:dms/ui/drawer_menu/home_screen/home_screen.dart';
import 'package:dms/ui/order_booking/retailer_detail/model/retailer_details_response.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_bloc.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_events.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_states.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailScreen extends StatefulWidget {
  final String storeId;
  const TaskDetailScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TextEditingController txtRemark = TextEditingController();
  RetailerDetailsModal? retailer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsBloc(),
      child: BlocBuilder<TaskDetailsBloc, TaskDetailStates>(
        builder: (context, state) {
          if (state is TaskDetailInitialState) {
            BlocProvider.of<TaskDetailsBloc>(context)
                .add(GetTaskDetailsEvent(storeId: widget.storeId));
          }
          if (state is TaskDetailLodingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetTaskDetailState) {
            retailer = state.retailer;
            if (txtRemark.text.isEmpty) {
              if (txtRemark.text != retailer!.remark) {
                txtRemark.text = state.retailer.remark;
              }
            }
          }
          if (state is TaskDetailFailureState) {
            return Center(
              child: Text(state.failureMessage),
            );
          }
          if (retailer == null) {
            return Container();
          }

          return Scaffold(
            appBar: _appBar(AppBar().preferredSize.height),
            backgroundColor: const Color(0xffF7F7F7),
            body: CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildListDelegate(
                    [
                      DetailGritItem(
                        value: "10-03-2022",
                        image: "assets/last_order.png",
                        name: StringConst.lastOrder,
                        type: 1,
                        retailerDetails: retailer!,
                      ),
                      const DetailGritItem(
                        value: "25-02-2022",
                        image: "assets/escalation.png",
                        name: StringConst.lastEscalation,
                        type: 2,
                      ),
                      const DetailGritItem(
                        value: "5",
                        image: "assets/pending_task.png",
                        name: StringConst.pendingTask,
                        type: 3,
                      ),
                      const DetailGritItem(
                        value: "25",
                        image: "assets/task_history.png",
                        name: StringConst.taskHistory,
                        type: 4,
                      ),
                    ],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.6,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 0,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 10, bottom: 5, top: 15),
                        child: Text(
                          StringConst.pendingTask,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff000000),
                            letterSpacing: 0.67,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 10, top: 5),
                        child: Container(
                          padding: retailer!.orderHistory.isNotEmpty
                              ? const EdgeInsets.fromLTRB(5, 10, 5, 0)
                              : const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(237, 237, 237, 0.25),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: retailer!.orderHistory.isNotEmpty
                              ? Column(
                                  children: List.generate(
                                    retailer!.orderHistory.length,
                                    (index) => Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        onTap: () {
                                          Utility.hideKeyboard();
                                          FocusScope.of(context).unfocus();
                                          showModalBottomSheet(
                                              context: context,
                                              shape: bottomSheetShape,
                                              isScrollControlled: true,
                                              builder: (context) => index == 0
                                                  ? const TaskDetailsBottomSheet()
                                                  : const EscalatedBottomSheet());
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          decoration: retailer!
                                                      .orderHistory[index] !=
                                                  retailer!.orderHistory.last
                                              ? const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Color(0xffC5C5C5),
                                                        width: 0.5),
                                                  ),
                                                )
                                              : null,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    flex: 4,
                                                    child: Text(
                                                      retailer!.uniqueCode,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            Color(0xff555555),
                                                        letterSpacing: 0.67,
                                                        fontSize: 15,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  const Flexible(
                                                    flex: 3,
                                                    child: Text(
                                                      "10-03-2022",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            Color(0xff777777),
                                                        letterSpacing: 0.67,
                                                        fontSize: 15,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Flexible(
                                                    child: Text(
                                                      "Partial delivery failure",
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff272727),
                                                        letterSpacing: 0.67,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Image(
                                                    image: AssetImage(
                                                      "assets/hit.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: const [
                                                  Image(
                                                    image: AssetImage(
                                                      "assets/time.png",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "5 days pending",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            Color(0xff555555),
                                                        letterSpacing: 0.67,
                                                        fontSize: 13,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Text(StringConst.taskNotFound),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            bottomNavigationBar: Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  shape: const RoundedRectangleBorder(),
                  child: const Text(
                    StringConst.outletInfoCaps,
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontSize: 20,
                      letterSpacing: 0.72,
                    ),
                  ),
                  color: const Color(0xff3D8FFF),
                  height: 50,
                  elevation: 0,
                  minWidth: MediaQuery.of(context).size.width / 2,
                ),
                Flexible(
                  child: MaterialButton(
                    shape: const RoundedRectangleBorder(),
                    onPressed: () {
                      Utility.hideKeyboard();
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      StringConst.exitCaps,
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 20,
                        letterSpacing: 0.72,
                      ),
                    ),
                    color: MColor.colorPrimary,
                    height: 50,
                    elevation: 0,
                    minWidth: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ],
            ),
          );
        },
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              onInit: (value) {},
                            ),
                          ),
                        );
                      },
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
              left: 45.0,
              right: 45.0,
              child: AppBar(
                elevation: 5,
                toolbarHeight: 60,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.white,
                primary: false,
                automaticallyImplyLeading: false,
                titleSpacing: 8,
                title: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        imageUrl: retailer!.outletPicture,
                        imageBuilder: (context, imageProvider) {
                          return Image(
                            image: imageProvider,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          );
                        },
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/placeholder.png"),
                        placeholder: (context, url) =>
                            Image.asset("assets/placeholder.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            retailer!.outlatName,
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
                          RichText(
                            text: const TextSpan(
                              text: "Enrolled ",
                              style: TextStyle(
                                color: Color(0xff555555),
                                fontSize: 11,
                                letterSpacing: 0.67,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "4 months ago",
                                  style: TextStyle(
                                    color: MColor.colorPrimary,
                                    fontSize: 11,
                                    letterSpacing: 0.67,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image(
                          width: 25,
                          height: 25,
                          image: AssetImage(
                            retailer!.enrollmentTypeId == "1"
                                ? "assets/key.png"
                                : "assets/hit.png",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
  final RetailerDetailsModal? retailerDetails;

  const DetailGritItem({
    Key? key,
    required this.image,
    required this.name,
    required this.value,
    required this.type,
    this.retailerDetails,
  }) : super(key: key);

  @override
  _DetailGritItemState createState() => _DetailGritItemState();
}

class _DetailGritItemState extends State<DetailGritItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(237, 237, 237, 0.25),
            blurRadius: 10,
          )
        ],
      ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: widget.type == 2 || widget.type == 4
              ? () {
                  Utility.hideKeyboard();
                  FocusScope.of(context).unfocus();

                  if (widget.type == 2) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: bottomSheetShape,
                        builder: (context) =>
                            const LastEscalationBottomSheet());
                  }
                  if (widget.type == 4) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: bottomSheetShape,
                        builder: (context) => const TaskHistoryBottomSheet());
                  }
                }
              : null,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Color(0xff303030),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.67,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.value,
                        style: const TextStyle(
                          color: Color(0xff555555),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskDetailItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;

  const TaskDetailItem(
      {Key? key,
      required this.image,
      required this.name,
      required this.value,
      required this.type})
      : super(key: key);

  @override
  _TaskDetailItemState createState() => _TaskDetailItemState();
}

class _TaskDetailItemState extends State<TaskDetailItem> {
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
                style: const TextStyle(
                    color: Color(0xff303030),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.29,
                child: Text(
                  widget.value,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                      color: Color(0xff555555),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
