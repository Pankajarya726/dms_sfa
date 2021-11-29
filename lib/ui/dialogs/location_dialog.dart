import 'package:flutter/material.dart';
import 'package:sfa/ui/bottom_sheet/filter_model/filter_model.dart';
import 'package:sfa/utility/colors.dart';

class LocationAlertDialog extends StatefulWidget {
  final List<FilterData> locationList;
  final Function(FilterData data) onLoctionSelect;
  const LocationAlertDialog(
      {Key? key, required this.locationList, required this.onLoctionSelect})
      : super(key: key);

  @override
  _LocationAlertDialogState createState() => _LocationAlertDialogState();
}

class _LocationAlertDialogState extends State<LocationAlertDialog> {
  TextEditingController filterController = TextEditingController();
  FilterData? selectedLocation;
  List<FilterData> locationList = [];
  List<FilterData> filterList = [];

  @override
  void initState() {
    locationList.addAll(widget.locationList);
    filterList.addAll(widget.locationList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                controller: filterController,
                style: const TextStyle(
                    color: colorGrayDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
                autocorrect: true,
                enableSuggestions: true,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: colorGrayLite,
                  hintText: "Search",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: colorGrayDark,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(12, 30, 0, 0),
                  hintStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colorGray),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  searchFilter(value);
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            height: MediaQuery.of(context).size.width * 0.70,
            width: MediaQuery.of(context).size.width * 0.90,
            color: reportBG,
            child: buidlLocationList(filterList),
          ),
        ],
      ),
    );
  }

  searchFilter(String? value) {
    if (value != null && value.isNotEmpty) {
      List<FilterData> filterData = [];

      filterData = widget.locationList
          .where(
              (item) => item.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filterList = filterData;
    } else {
      filterList = widget.locationList;
    }

    setState(() {});
  }

  buidlLocationList(List<FilterData> listData) {
    return ListView.separated(
      shrinkWrap: false,
      itemCount: listData.length,
      primary: false,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            widget.onLoctionSelect(listData[index]);
            Navigator.pop(context);
            // setState(() {
            //   // locationNameController.text = listData[index].name;
            //   selectedLocation = listData[index];
            // });
          },
          contentPadding: const EdgeInsets.all(0),
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          dense: true,
          title: Text(
            listData[index].name,
            style: const TextStyle(
              color: colorGrayDark,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        );
      },
      separatorBuilder: (context, int index) {
        return const Divider(
          color: colorGray,
        );
      },
    );
  }
}
