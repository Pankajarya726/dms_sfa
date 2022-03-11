import 'package:dms/listeners/select_beat_listerner.dart';
import 'package:dms/ui/add_store/outlet_information/outlet_information.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/filter_retailer_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/route_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/sort_retailer_bottom_sheet.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailer_bloc.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_event.dart';
import 'package:dms/ui/order_booking/retailers_list/bloc/retailers_state.dart';
import 'package:dms/ui/order_booking/retailers_list/model/get_all_beats_response.dart';
import 'package:dms/ui/order_booking/retailers_list/retailers_tab.dart';
import 'package:dms/ui/order_booking/search_retailers/search_retailier_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RetailerListScreen extends StatefulWidget {
  const RetailerListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RetailerListScreenState createState() => _RetailerListScreenState();
}

class _RetailerListScreenState extends State<RetailerListScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  RetailersBloc retailersBloc = RetailersBloc();
  List<BeatsModal> beats = [];
  BeatsModal? selectedBeat;
  SelectBeatListener? selectBeatListener;
  String selectedDay = "";
  String selectedPrioType = "";
  String sortSelected = "";

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                            day: selectedDay,
                            type: selectedPrioType,
                            onFilter: (day, type, beatModal) {
                              selectedDay = day;
                              selectedPrioType = type;
                              selectedBeat = beatModal;
                              if (selectBeatListener != null) {
                                selectBeatListener!
                                    .onBeatSelect(selectedBeat!, day, type);
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
                Navigator.pop(context);
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchRetailerScreen()));
                      },
                      decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: const TextStyle(fontSize: 16),
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              gapPadding: 2,
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xffC5C5C5))),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              gapPadding: 2,
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xffC5C5C5))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              gapPadding: 2,
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xffC5C5C5))),
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
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        onTap: (index) {
                          // if (selectBeatListener != null) {
                          //   selectBeatListener!.onBeatSelect(
                          //       selectedBeat!, selectedDay, selectedPrioType);
                          // }
                          debugPrint("select-tag-->${selectedBeat!.name}");
                        },
                        tabs: [
                          Tab(
                            child: Text(
                              "Not Connected",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .merge(TextStyle(
                                      color: const Color(0xff303030)
                                          .withOpacity(0.85),
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "No Order",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .merge(TextStyle(
                                      color: const Color(0xff303030)
                                          .withOpacity(0.85),
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Order",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .merge(TextStyle(
                                      color: const Color(0xff303030)
                                          .withOpacity(0.85),
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
              BlocBuilder<RetailersBloc, RetailerState>(
                  builder: (context, state) {
                if (state is RetailerInitState) {
                  retailersBloc.add(GetBeatEvent());
                }
                if (state is GetBeatState) {
                  beats = state.beats;
                  selectedBeat = beats.first;
                }
                return SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: BeatWidget(
                    tags: beats,
                    onSelect: (BeatsModal tag) {
                      debugPrint("onBeatSelect-->${tag.name}");
                      selectedBeat = tag;
                      if (selectBeatListener != null) {
                        selectBeatListener!.onBeatSelect(
                            selectedBeat!, selectedDay, selectedPrioType);
                      }
                    },
                  ),
                );
              }),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RetailerTab(
                      selectedBeat: selectedBeat == null
                          ? BeatsModal(id: "", name: "All")
                          : selectedBeat!,
                      index: 1,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    RetailerTab(
                      selectedBeat: selectedBeat == null
                          ? BeatsModal(id: "", name: "All")
                          : selectedBeat!,
                      index: 2,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                    RetailerTab(
                      selectedBeat: selectedBeat == null
                          ? BeatsModal(id: "", name: "All")
                          : selectedBeat!,
                      index: 3,
                      onInit: (SelectBeatListener listener) {
                        selectBeatListener = listener;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
