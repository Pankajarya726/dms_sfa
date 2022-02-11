import 'dart:io';
import 'package:dms/ui/add_store/bloc/edit_store_bloc.dart';
import 'package:dms/ui/common_bloc/common_bloc.dart';
import 'package:dms/ui/userlocation_bloc/userlocation_bloc.dart';
import 'package:flutter/material.dart';

class OutletInformation extends StatefulWidget {
  const OutletInformation({Key? key}) : super(key: key);

  @override
  State<OutletInformation> createState() => _OutletInformationState();
}

class _OutletInformationState extends State<OutletInformation> {
  Object selectEnrollmentRadio = "";
  Object existingRetailerRadio = "";
  Object isKRORadio = "";
  File? outletPhotoFile;
  String? outletFileName;
  CommonBloc commonBloc = CommonBloc();
  UserLocationBloc userLocationBloc = UserLocationBloc();
  EditStoreBloc editStoreBloc = EditStoreBloc();
  TextEditingController txtSelectDistrictController = TextEditingController();
  TextEditingController txtSelectDistributorController =
      TextEditingController();
  TextEditingController txtSelectBeatNameController = TextEditingController();
  TextEditingController txtOrderBookingController = TextEditingController();
  TextEditingController txtOutletNameController = TextEditingController();
  TextEditingController txtLatitudeController = TextEditingController();
  TextEditingController txtLongtitudeController = TextEditingController();
  TextEditingController txtAddressController = TextEditingController();
  TextEditingController txtPincodeController = TextEditingController();
  TextEditingController txtLandmarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
