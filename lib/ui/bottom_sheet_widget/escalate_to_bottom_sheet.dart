import 'dart:async';
import 'dart:collection';
import 'package:dms/ui/task/task_details/bloc/task_details_bloc.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_events.dart';
import 'package:dms/ui/task/task_details/bloc/task_details_states.dart';
import 'package:dms/ui/task/task_details/model/retailer_details_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EscalateToBottomSheet extends StatefulWidget {
  final PendingTaskModal? pendingTaskModal;
  final String remark;
  final String elapseDays;
  final String retailerId;
  final Function() onTaskEscalated;
  const EscalateToBottomSheet({
    Key? key,
    required this.pendingTaskModal,
    required this.remark,
    required this.elapseDays,
    required this.retailerId,
    required this.onTaskEscalated,
  }) : super(key: key);

  @override
  _EscalateToBottomSheetState createState() => _EscalateToBottomSheetState();
}

class _EscalateToBottomSheetState extends State<EscalateToBottomSheet> {
  String groupValue = "";
  List<EscalationTo> escalationTypeList = [];
  StreamController<List<EscalationTo>> escalationTypeStream =
      StreamController();
  TaskDetailsBloc taskDetailsBloc = TaskDetailsBloc();

  @override
  void initState() {
    super.initState();
    escalationTypeList = widget.pendingTaskModal!.escalationTo;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
        minHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: StreamBuilder<List<EscalationTo>>(
            stream: escalationTypeStream.stream,
            initialData: escalationTypeList,
            builder: (context, snapshot) {
              if (snapshot.data!.isEmpty) {
                return const IntrinsicHeight(
                  child: Center(
                    child: Text("Data not found"),
                  ),
                );
              }
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select which person do you wish to escalate this task",
                      style: TextStyle(
                        fontSize: 19,
                        color: MColor.colorPrimary,
                        letterSpacing: 0.67,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            snapshot.data!.length,
                            (index) => RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              value: snapshot.data![index].id,
                              groupValue: groupValue,
                              title: Text(
                                snapshot.data![index].name,
                                style: const TextStyle(
                                  fontSize: 17.0,
                                  color: MColor.backButton,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onChanged: (value) {
                                groupValue = value!;
                                escalationTypeStream.add(snapshot.data!);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocProvider(
                      create: (context) => taskDetailsBloc,
                      child: BlocListener<TaskDetailsBloc, TaskDetailStates>(
                        listener: (context, state) {
                          if (state is EscalateTaskState) {
                            Utility.showToast(state.responseMessage);
                            widget.onTaskEscalated();
                            Navigator.pop(context);
                          }
                          if (state is EscalateTaskFailureState) {
                            Utility.showToast(state.failureMessage);
                            Navigator.pop(context);
                          }
                        },
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> input =
                                  HashMap<String, dynamic>();
                              input["status"] = "1";
                              input["task_id"] = widget.pendingTaskModal!.id;
                              input["retailer_id"] = widget.retailerId;
                              input["escalate_user_id"] = groupValue;
                              input["remark"] = widget.remark;
                              input["elapse_days"] = widget.elapseDays;
                              taskDetailsBloc
                                  .add(EscalateTaskEvent(input: input));
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(180, 55)),
                              backgroundColor: MaterialStateProperty.all(
                                  MColor.colorPrimary),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            child: const Text(
                              StringConst.done,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }
}
