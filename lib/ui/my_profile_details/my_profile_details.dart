import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details_bloc/my_profile_details_bloc.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details_bloc/my_profile_details_event.dart';
import 'package:sfa/ui/my_profile_details/my_profile_details_bloc/my_profile_details_state.dart';
import 'package:sfa/utility/colors.dart';

class MyProfileDetails extends StatefulWidget {
  const MyProfileDetails({Key? key}) : super(key: key);

  @override
  _MyProfileDetailsState createState() => _MyProfileDetailsState();
}

class _MyProfileDetailsState extends State<MyProfileDetails> {
  MyProfileDetailsBloc myProfileDetailsBloc = MyProfileDetailsBloc();
  DateTime? dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myProfileDetailsBloc,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IntrinsicHeight(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: colorPrimary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            showPicker();
                          },
                          child: SizedBox(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "assets/calendar.png",
                                  width: 20,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                BlocBuilder<MyProfileDetailsBloc,
                                    MyProfileDetailsState>(
                                  builder: (context, state) {
                                    return Text(
                                      DateFormat("dd-MMM-yyyy")
                                          .format(dateTime!),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  dateTime = DateTime(dateTime!.year,
                                      dateTime!.month, dateTime!.day - 1);
                                  myProfileDetailsBloc.add(
                                      MyProfileDetailsDecrementDateEvent(
                                          dateTime: dateTime!));
                                },
                                child: Image.asset(
                                  "assets/2x/icon_previous.png",
                                  width: 25,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  dateTime = DateTime(dateTime!.year,
                                      dateTime!.month, dateTime!.day + 1);
                                  myProfileDetailsBloc.add(
                                      MyProfileDetailsIncrementDateEvent(
                                          dateTime: dateTime!));
                                },
                                child: Image.asset(
                                  "assets/2x/icon_next.png",
                                  width: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: reportBG,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      //from here
                      child: BlocConsumer<MyProfileDetailsBloc,
                          MyProfileDetailsState>(
                        listener: (context, state) {
                          if (state is MyProfileDetailsSelectDateState) {
                            dateTime = state.dateTime;
                            var format = DateFormat("yyyy-MM-dd");
                            myProfileDetailsBloc.add(
                              MyProfileDetailsInitialEvent(
                                  currentDate: format.format(dateTime!)),
                            );
                          }
                          if (state is MyProfileDetailsIncrementDateState) {
                            dateTime = state.dateTime;
                            var format = DateFormat("yyyy-MM-dd");
                            myProfileDetailsBloc.add(
                              MyProfileDetailsInitialEvent(
                                  currentDate: format.format(dateTime!)),
                            );
                          }
                          if (state is MyProfileDetailsDecrementDateState) {
                            dateTime = state.dateTime;
                            var format = DateFormat("yyyy-MM-dd");
                            myProfileDetailsBloc.add(
                              MyProfileDetailsInitialEvent(
                                  currentDate: format.format(dateTime!)),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is MyProfileDetailsInitialState) {
                            var format = DateFormat("yyyy-MM-dd");
                            myProfileDetailsBloc.add(
                                MyProfileDetailsInitialEvent(
                                    currentDate: format.format(dateTime!)));
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is MyProfileDetailsLoadingState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (state is MyProfileDetailsInitialSuccessState) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 18, 12, 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Clock in : ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: state
                                                    .detailsStatusResponse
                                                    .data!
                                                    .clockInTime,
                                                style: const TextStyle(
                                                  color: colorGreen,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: 'Clock out : ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                              TextSpan(
                                                text: state
                                                    .detailsStatusResponse
                                                    .data!
                                                    .clockOutTime,
                                                style: const TextStyle(
                                                  color: colorPrimary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 6, 0, 0),
                                    child: const Text(
                                      "PJP",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 0, 8),
                                    child: Text(
                                      state.detailsStatusResponse.data!
                                          .pjpDescription,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 0, 0),
                                    child: const Text(
                                      "Working Plan",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 0, 4),
                                    child: Text(
                                      state.detailsStatusResponse.data!
                                          .inWorkingPlan,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 14, 0, 4),
                                    child: const Text(
                                      "Clock-in Salfie",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: 150,
                                      width: 150,
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 4, 0, 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(state
                                                .detailsStatusResponse
                                                .data!
                                                .inImage),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ]),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 6, 0, 4),
                                    child: const Text(
                                      "Comment",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 0, 4),
                                    child: Text(
                                      state
                                          .detailsStatusResponse.data!.comments,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 14, 0, 4),
                                    child: const Text(
                                      "Clock-out Salfie",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: 150,
                                      width: 150,
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 4, 0, 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(state
                                                .detailsStatusResponse
                                                .data!
                                                .outImage),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            );
                          }
                          if (state is MyProfileDetailsFailureState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Text(state.failureMessage),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPicker() async {
    dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());

    myProfileDetailsBloc
        .add(MyProfileDetailsSelectDateEvent(dateTime: dateTime!));
  }
}
