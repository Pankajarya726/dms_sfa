import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/drawer_menu/home_screen/home_screen.dart';
import 'package:dms/ui/order_booking/order_confirmation/order_summery_table.dart';
import 'package:dms/ui/order_booking/order_details/bloc/order_detail_bloc.dart';
import 'package:dms/ui/order_booking/order_details/bloc/order_detail_event.dart';
import 'package:dms/ui/order_booking/order_details/bloc/order_detail_state.dart';
import 'package:dms/ui/order_booking/order_details/model/get_order_response.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_retailers_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailScreen extends StatefulWidget {
  final RetailersModal retailer;

  const OrderDetailScreen({Key? key, required this.retailer}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetailBloc orderBloc = OrderDetailBloc();

  String orderId = "";
  List<Product> product = [];
  Task? task;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => orderBloc,
      child: Scaffold(
        appBar: _appBar(AppBar().preferredSize.height),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              BlocBuilder<OrderDetailBloc, OrderDetailState>(
                builder: (context, state) {
                  if (state is OrderDetailInitialState) {
                    orderBloc.add(GetOrderEvent(retailerId: widget.retailer.customerId, beatId: widget.retailer.beatId));
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is GetOrderFailureState) {
                    return Container();
                  }

                  if (state is GetOrderSuccessState) {
                    product = state.products;
                    orderId = state.orders.orderId.toString();
                    task = state.task;

                    return const OrderSummeryTable();
                  }
                  return Container();
                },
              ),
              BlocBuilder<OrderDetailBloc, OrderDetailState>(builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Remarks:",
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        task != null ? task!.escalationTag : "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              })
            ]))
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: Row(
            children: [
              MaterialButton(
                elevation: 0,
                onPressed: () {},
                shape: const RoundedRectangleBorder(),
                height: 50,
                minWidth: MediaQuery.of(context).size.width / 2,
                color: const Color(0xff3D8FFF),
                child: const Text(
                  "OUTLET INFO",
                  style: TextStyle(color: Colors.white, letterSpacing: 0.5),
                ),
              ),
              MaterialButton(
                elevation: 0,
                onPressed: () {},
                shape: const RoundedRectangleBorder(),
                height: 50,
                color: const Color(0xff2CB743),
                minWidth: MediaQuery.of(context).size.width / 2,
                child: const Text(
                  "UPDATE",
                  style: TextStyle(color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
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
                        imageUrl: widget.retailer.outletPicture,
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
                          Text(
                            widget.retailer.outlatName,
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
                            widget.retailer.beatName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image(
                          width: 25,
                          height: 25,
                          image: AssetImage(widget.retailer.enrollmentTypeId == "1" ? "assets/retailer.png" : "assets/tele.png"),
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
