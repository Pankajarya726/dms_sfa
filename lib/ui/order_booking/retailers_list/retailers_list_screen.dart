import 'dart:async';
import 'dart:developer';

import 'package:dms/listeners/select_beat_listener.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/add_store/outlet_information/outlet_information.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_retailer_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/route_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/sort_retailer_bottom_sheet.dart';
import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_tab.dart';
import 'package:dms/ui/order_booking/search_retailers/search_retailier_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class RetailerListScreen extends StatefulWidget {
  const RetailerListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RetailerListScreenState createState() => _RetailerListScreenState();
}

class _RetailerListScreenState extends State<RetailerListScreen> with TickerProviderStateMixin {
  late TabController tabController;
  RetailersBloc retailersBloc = RetailersBloc();
  List<BeatsModal> beatList = [];
  SelectBeatListener? selectBeatListener;
  String selectedDay = DateFormat("EEEE").format(DateTime.now());
  String selectedEnrollmentType = "";
  String sortSelected = "";
  BeatsModal? selectedBeat;
  StreamController<List<BeatsModal>> beatStream = StreamController();
  StreamController<int> tabStream = StreamController();

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    getBeats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DrawerScreen()), ModalRoute.withName("/"));
        }
        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: BlocProvider<RetailersBloc>(
          create: (context) => retailersBloc,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: bottomSheetShape,
                          builder: (context) {
                            return SortingRetailersBottomSheet(
                              selectedType: sortSelected,
                              onSelect: (selected) {
                                sortSelected = selected;
                                if (selectBeatListener != null) {
                                  selectBeatListener!.onSorting(sortSelected);
                                }
                              },
                            );
                          });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image(
                        width: 25,
                        height: 25,
                        image: AssetImage("assets/sorting.png"),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: bottomSheetShape,
                          builder: (context) {
                            return const RouteBottomSheet();
                          });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image(
                        width: 25,
                        height: 25,
                        image: AssetImage("assets/route.png"),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        StringConst.retailers,
                        style: TextStyle(
                          color: MColor.backButton,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: MaterialButton(
                      height: 30,
                      minWidth: 50,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OutletInformation(),
                          ),
                        );
                      },
                      color: MColor.colorSecondary,
                      child: const Text(
                        StringConst.addCaps,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: bottomSheetShape,
                          builder: (context) {
                            return FilterRetailerBottomSheet(
                              beatList: beatList,
                              day: selectedDay,
                              type: selectedEnrollmentType,
                              beat: selectedBeat!,
                              onFilter: (String day, String enrollmentType, BeatsModal selectedBeat, List<BeatsModal> beats) {
                                log("filter--->${beats.toList()}");
                                selectedDay = day.isEmpty ? DateFormat("EEEE").format(DateTime.now()) : day;
                                selectedEnrollmentType = enrollmentType;
                                this.selectedBeat = selectedBeat;
                                if (beats.isNotEmpty) {
                                  beatList = beats;
                                  beatStream.add(beatList);
                                }

                                if (selectBeatListener != null) {
                                  selectBeatListener!.onBeatSelect(selectedBeat, selectedDay, selectedEnrollmentType);
                                }
                              },
                            );
                          });
                    },
                    icon: const Image(
                      width: 30,
                      image: AssetImage("assets/filter.png"),
                    ),
                  )
                ],
              ),
              leadingWidth: 45,
              leading: IconButton(
                splashRadius: 20,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (_) => const DrawerScreen()), ModalRoute.withName("/"));
                  }
                },
                icon: const Image(
                  image: AssetImage("assets/back.png"),
                  color: Colors.black,
                ),
              ),
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 16),
                        readOnly: true,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchRetailerScreen()));
                        },
                        decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: const TextStyle(fontSize: 16),
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                gapPadding: 2,
                                borderSide: const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                gapPadding: 2,
                                borderSide: const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                gapPadding: 2,
                                borderSide: const BorderSide(width: 1, color: Color(0xffC5C5C5))),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xff555555),
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: const Color(0xffEDEDED),
                      child: TabBar(
                          controller: tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 3,
                          indicatorColor: MColor.colorPrimary,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                          indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
                          onTap: (index) {
                            tabStream.add(index + 1);
                            // if (selectBeatListener != null) {
                            //   selectBeatListener!.onBeatSelect(selectedBeat!, selectedDay, selectedEnrollmentType);
                            // }
                            // debugPrint("select-tag-->${selectedBeat!.name}");
                          },
                          tabs: [
                            Tab(
                              child: Text(
                                "Not Connected",
                                style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                                    color: const Color(0xff303030).withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "No Order",
                                style: Theme.of(context).textTheme.bodyText2!.merge(TextStyle(
                                    color: const Color(0xff303030).withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Order",
                                style: Theme.of(context).textTheme.bodyText2!.merge(TextStyle(
                                    color: const Color(0xff303030).withOpacity(0.85),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                StreamBuilder<List<BeatsModal>>(
                    stream: beatStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        List<BeatsModal> beats = snapshot.data!;

                        log("filter--->${beats.toList()}");
                        return SizedBox(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          child: BeatWidget(
                            tags: beats,
                            selectedBeat: selectedBeat,
                            onSelect: (BeatsModal tag) {
                              debugPrint("onBeatSelect-->${tag.name}");
                              selectedBeat = tag;
                              if (selectBeatListener != null) {
                                selectBeatListener!.onBeatSelect(selectedBeat!, selectedDay, selectedEnrollmentType);
                              }
                            },
                          ),
                        );
                      }
                      return Container();
                    }),

                /*   BlocBuilder<RetailersBloc, RetailerState>(builder: (context, state) {
                  if (state is RetailerInitState) {
                    retailersBloc.add(GetBeatEvent());
                  }
                  if (beats.isEmpty) {
                    if (state is GetBeatState) {
                      beats = state.beats;
                      if (selectedBeat == null) {
                        selectedBeat = beats.first;
                      }
                    }
                  }

                  return SizedBox(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: BeatWidget(
                      tags: beats,
                      selectedBeat: selectedBeat != null ? selectedBeat!.name : "All",
                      onSelect: (BeatsModal tag) {
                        debugPrint("onBeatSelect-->${tag.name}");
                        selectedBeat = tag;
                        if (selectBeatListener != null) {
                          selectBeatListener!.onBeatSelect(selectedBeat!, selectedDay, selectedEnrollmentType);
                        }
                      },
                    ),
                  );
                }),*/

                Expanded(
                    child: StreamBuilder<int>(
                  stream: tabStream.stream,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return RetailerTab(
                        selectedBeat: selectedBeat == null ? BeatsModal(id: "", name: "All") : selectedBeat!,
                        index: snap.data!,
                        day: selectedDay,
                        onInit: (SelectBeatListener listener) {
                          selectBeatListener = listener;
                        },
                      );
                    }
                    return Container();
                  },
                )),
                /* Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      RetailerTab(
                        selectedBeat: selectedBeat == null ? BeatsModal(id: "", name: "All") : selectedBeat!,
                        index: 1,
                        day: selectedDay,
                        onInit: (SelectBeatListener listener) {
                          selectBeatListener = listener;
                        },
                      ),
                      RetailerTab(
                        selectedBeat: selectedBeat == null ? BeatsModal(id: "", name: "All") : selectedBeat!,
                        index: 2,
                        day: selectedDay,
                        onInit: (SelectBeatListener listener) {
                          selectBeatListener = listener;
                        },
                      ),
                      RetailerTab(
                        selectedBeat: selectedBeat == null ? BeatsModal(id: "", name: "All") : selectedBeat!,
                        index: 3,
                        day: selectedDay,
                        onInit: (SelectBeatListener listener) {
                          selectBeatListener = listener;
                        },
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  getBeats() async {
    if (await Network.isConnected()) {
      DateTime dateTime = await NTP.now().timeout(const Duration(seconds: 5), onTimeout: () {
        return DateTime.now();
      });
      Map<String, dynamic> input = {"day": DateFormat("EEEE").format(dateTime)};
      GetAllBeatsResponse response = await repository.getBeatByOrderBookingDay(input);
      if (response.success) {
        if (response.data!.length > 1) {
          beatList.add(BeatsModal(id: "", name: "All"));
        }
        beatList.addAll(response.data!);
        beatStream.add(beatList);
        tabStream.add(tabController.index + 1);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}
