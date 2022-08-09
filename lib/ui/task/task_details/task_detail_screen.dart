import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/escalated_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/last_escalation_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/task_details_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/task_history_bottom_sheet.dart';
import 'package:dms/ui/drawer_menu/home_screen/home_screen.dart';
import 'package:dms/ui/order_booking/retailer_detail/retailer_detail_screen.dart';
import 'package:dms/ui/task/task/model/get_retailers_task_response.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_bloc.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_events.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_states.dart';
import 'package:dms/ui/task/task_details/model/retailer_details_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TaskDetailScreen extends StatefulWidget {
  final RetailersTaskModal modal;
  const TaskDetailScreen({Key? key, required this.modal}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TextEditingController txtRemark = TextEditingController();
  List<PendingTaskModal> pendingTaskList = [];
  DateTime? currentDate;
  TaskDetailsBloc taskDetailsBloc = TaskDetailsBloc();
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    debugPrint("months pending = ${widget.modal.totalMonths}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      backgroundColor: const Color(0xffF7F7F7),
      body: BlocProvider(
        create: (context) => taskDetailsBloc,
        child: SmartRefresher(
          primary: false,
          controller: refreshController,
          onRefresh: onRefresh,
          enablePullDown: true,
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                delegate: SliverChildListDelegate(
                  [
                    DetailGritItem(
                      value: widget.modal.lastOrder.isNotEmpty ? widget.modal.lastOrder : "No order yet!",
                      image: "assets/last_order.png",
                      name: StringConst.lastOrder,
                      type: 1,
                      modal: widget.modal,
                    ),
                    DetailGritItem(
                      value: widget.modal.lastEscalation.isNotEmpty && widget.modal.lastEscalation.first.reassignDate.isNotEmpty
                          ? widget.modal.lastEscalation.first.reassignDate
                          : "",
                      image: "assets/escalation.png",
                      name: StringConst.lastEscalation,
                      type: 2,
                      modal: widget.modal,
                    ),
                    DetailGritItem(
                      value: widget.modal.pendingTask.isNotEmpty ? widget.modal.pendingTask : "0",
                      image: "assets/pending_task.png",
                      name: StringConst.pendingTask,
                      type: 3,
                      modal: widget.modal,
                    ),
                    DetailGritItem(
                      value: widget.modal.taskHistory.isNotEmpty ? widget.modal.taskHistory : "0",
                      image: "assets/task_history.png",
                      name: StringConst.taskHistory,
                      type: 4,
                      modal: widget.modal,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 10, bottom: 0, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            StringConst.storeInfo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     // Navigator.push(
                          //     //   context,
                          //     //   MaterialPageRoute(builder: (context) => const OutletInformation()),
                          //     // );
                          //   },
                          //   padding: EdgeInsets.zero,
                          //   // splashRadius: 13,
                          //   icon: Container(
                          //     height: 25,
                          //     width: 25,
                          //     decoration: const BoxDecoration(
                          //       color: MColor.colorSecondary,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(15)),
                          //     ),
                          //     child: const Center(
                          //       child: Icon(
                          //         Icons.edit,
                          //         color: Colors.white,
                          //         size: 18,
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 5),
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
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: RetailerDetailItem(
                                  value: widget.modal.ownerName,
                                  image: "assets/user.png",
                                  name: StringConst.ownerName,
                                  type: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                  width: 1,
                                  height: 30,
                                  color: const Color(0xffC5C5C5),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: RetailerDetailItem(
                                  value: widget.modal.orderBookingDay1 +
                                      (widget.modal.orderBookingDay2.isEmpty ? "" : "," + widget.modal.orderBookingDay2),
                                  image: "assets/telephone.png",
                                  name: StringConst.callingDay,
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
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      if (widget.modal.primaryMobile.isNotEmpty) {
                                        await launchUrlString("tel:${widget.modal.primaryMobile}");
                                      } else {
                                        Utility.showToast("Mobile number not available");
                                      }
                                    } catch (e) {
                                      Utility.showToast(e.toString());
                                    }
                                  },
                                  child: RetailerDetailItem(
                                    value: widget.modal.primaryMobile,
                                    image: "assets/phone_call.png",
                                    name: StringConst.primaryNo,
                                    type: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                  width: 1,
                                  height: 30,
                                  color: const Color(0xffC5C5C5),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      if (widget.modal.secondaryMobile.isNotEmpty) {
                                        await launchUrlString("tel:${widget.modal.secondaryMobile}");
                                      } else {
                                        Utility.showToast("Mobile number not available");
                                      }
                                    } catch (e) {
                                      Utility.showToast(e.toString());
                                    }
                                  },
                                  child: RetailerDetailItem(
                                    value: widget.modal.secondaryMobile.isEmpty ? "Not Given" : widget.modal.secondaryMobile,
                                    image: "assets/phone_call.png",
                                    name: StringConst.secondaryNo,
                                    type: 1,
                                  ),
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
                                    RichText(
                                        text: const TextSpan(children: [
                                      TextSpan(
                                        text: StringConst.address,
                                        style: TextStyle(
                                          color: Color(0xff303030),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " | ",
                                        style: TextStyle(
                                          color: MColor.colorPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: StringConst.landmark,
                                        style: TextStyle(
                                          color: Color(0xff303030),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ])),
                                    // const Text(
                                    //   StringConst.address + " | " + StringConst.landmark,
                                    //   style: TextStyle(
                                    //     color: Color(0xff303030),
                                    //     fontSize: 15,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.80,
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                          text: widget.modal.primaryAddress,
                                          style: const TextStyle(
                                            color: Color(0xff303030),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: " | ",
                                          style: TextStyle(
                                            color: MColor.colorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.modal.landmark,
                                          style: const TextStyle(
                                            color: Color(0xff303030),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ])),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15, right: 10, bottom: 5, top: 15),
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
                    BlocBuilder<TaskDetailsBloc, TaskDetailStates>(
                      builder: (context, state) {
                        if (state is TaskDetailInitialState) {
                          taskDetailsBloc.add(GetPendingTaskEvent(retailerId: widget.modal.retailerId, beatId: widget.modal.beatId));
                        }

                        if (state is TaskDetailLodingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is GetPendingTaskState) {
                          currentDate = state.currentDate;
                          pendingTaskList = state.pendingTask;
                        }

                        if (state is TaskDetailFailureState) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                              child: const Text(StringConst.taskNotFound),
                            ),
                          );
                        }

                        if (pendingTaskList.isEmpty) {
                          return const Text(StringConst.taskNotFound);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
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
                              child: Column(
                                children: List.generate(
                                  pendingTaskList.length,
                                  (index) {
                                    int days = 1;
                                    String daysPending = "";
                                    if (pendingTaskList[index].taskDate.isNotEmpty) {
                                      DateTime enrolledDate = DateTime.parse(pendingTaskList[index].taskDate);
                                      days = days + currentDate!.difference(enrolledDate).inDays;
                                      if (days < 2) {
                                        daysPending = days.toString() + " day pending";
                                      } else {
                                        daysPending = days.toString() + " days pending";
                                      }
                                    }

                                    return Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        onTap: () {
                                          if (pendingTaskList[index].action == "1") {
                                            Utility.hideKeyboard();
                                            FocusScope.of(context).unfocus();
                                            showModalBottomSheet(
                                                context: context,
                                                shape: bottomSheetShape,
                                                isScrollControlled: true,
                                                builder: (context) => pendingTaskList[index].escalationTo.isEmpty
                                                    ? TaskDetailsBottomSheet(
                                                        pendingTaskModal: pendingTaskList[index],
                                                        elapseDays: days.toString(),
                                                        retailerId: widget.modal.retailerId,
                                                        onTaskResolve: () {
                                                          Navigator.pop(context);
                                                        },
                                                      )
                                                    : EscalatedBottomSheet(
                                                        pendingTaskModal: pendingTaskList[index],
                                                        retailerId: widget.modal.retailerId,
                                                        elapseDays: days.toString(),
                                                        onTaskResolve: (done) {
                                                          // if (done
                                                          //     .isEmpty) {
                                                          //   taskDetailsBloc.add(GetPendingTaskEvent(
                                                          //       retailerId: widget
                                                          //           .modal
                                                          //           .retailerId,
                                                          //       beatId: widget
                                                          //           .modal
                                                          //           .beatId));
                                                          // } else {
                                                          //   Navigator.pop(
                                                          //       context);
                                                          // }
                                                          Navigator.pop(context);
                                                        },
                                                      ));
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                          decoration: pendingTaskList[index] != pendingTaskList.last
                                              ? const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(color: Color(0xffC5C5C5), width: 0.5),
                                                  ),
                                                )
                                              : null,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    flex: 4,
                                                    child: Text(
                                                      pendingTaskList[index].taskCode,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        color: Color(0xff555555),
                                                        letterSpacing: 0.67,
                                                        fontSize: 15,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Text(
                                                      pendingTaskList[index].taskDate,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        color: Color(0xff777777),
                                                        letterSpacing: 0.67,
                                                        fontSize: 15,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: pendingTaskList[index].escalationTag.isNotEmpty
                                                        ? Text(
                                                            pendingTaskList[index].escalationTag.first.tagName,
                                                            maxLines: 3,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff272727),
                                                              letterSpacing: 0.67,
                                                              fontSize: 15,
                                                            ),
                                                          )
                                                        : const Text(""),
                                                  ),
                                                  Image(
                                                    image: AssetImage(
                                                      pendingTaskList[index].taskType == "HIT"
                                                          ? "assets/hit.png"
                                                          : pendingTaskList[index].taskType == "ST"
                                                              ? "assets/special.png"
                                                              : "assets/key.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Image(
                                                    image: AssetImage(
                                                      "assets/time.png",
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      daysPending,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        color: Color(0xff555555),
                                                        letterSpacing: 0.67,
                                                        fontSize: 13,
                                                        overflow: TextOverflow.ellipsis,
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
                                    );
                                  },
                                ),
                              )),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          /* MaterialButton(
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
          ),*/
          MaterialButton(
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
            minWidth: MediaQuery.of(context).size.width,
          ),
        ],
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                        imageUrl: widget.modal.outletPicture,
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.modal.outletName.isNotEmpty
                              ? Text(
                                  widget.modal.outletName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : const Text(""),
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Enrolled ",
                              style: const TextStyle(
                                color: Color(0xff555555),
                                fontSize: 11,
                                letterSpacing: 0.67,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.modal.totalMonths,
                                  style: const TextStyle(
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
                            widget.modal.taskType == "HIT"
                                ? "assets/hit.png"
                                : widget.modal.taskType == "ST"
                                    ? "assets/special.png"
                                    : "assets/key.png",
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

  void onRefresh() async {
    pendingTaskList.clear();
    taskDetailsBloc.add(GetPendingTaskEvent(retailerId: widget.modal.retailerId, beatId: widget.modal.beatId));
    refreshController.refreshCompleted();
  }
}

class DetailGritItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;
  final RetailersTaskModal modal;

  const DetailGritItem({
    Key? key,
    required this.image,
    required this.name,
    required this.value,
    required this.type,
    required this.modal,
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
                        builder: (context) => LastEscalationBottomSheet(
                            lastEscalation: widget.modal.lastEscalation.isNotEmpty ? widget.modal.lastEscalation.first : null));
                  }
                  if (widget.type == 4) {
                    widget.value != "0"
                        ? showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: bottomSheetShape,
                            builder: (context) => TaskHistoryBottomSheet(
                                  modal: widget.modal,
                                ))
                        : null;
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
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

  const TaskDetailItem({Key? key, required this.image, required this.name, required this.value, required this.type}) : super(key: key);

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
