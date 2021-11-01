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
                                  "assets/icon_previous.png",
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
                                  "assets/icon_next.png",
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is MyProfileDetailsInitialSuccessState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Clock in : ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '8:00:50 AM',
                                              style: TextStyle(
                                                color: colorGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'Clock out : ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            TextSpan(
                                              text: '4:00:50 PM',
                                              style: TextStyle(
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
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "PJP",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "Working Plan",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "Clock-in Selfie",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 150,
                                    width: 150,
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      color: colorGray,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "Comment",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "Clock-out Selfie",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 150,
                                    width: 150,
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      color: colorGray,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (state is MyProfileDetailsFailureState) {
                              return Center(
                                child: Text(state.failureMessage),
                              );
                            }
                            return Container();
                          },
                        ),
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
