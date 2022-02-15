import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';

class ProductInformation extends StatefulWidget {
  final Map<String, dynamic> outletInfo;
  final Map<String, dynamic> ownerInfo;
  const ProductInformation(
      {Key? key, required this.outletInfo, required this.ownerInfo})
      : super(key: key);

  @override
  State<ProductInformation> createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> {
  List<String> names = [
    "Washing powder/cake",
    "Biscuits",
    "Spices",
    "Tea & Coffee",
    "Bathing Soaps",
    "Toothpaste/Powder",
    "Pickles Jam & ketchups",
    "Dish Washing Soap",
  ];
  List<String> icons = [
    "assets/user.png",
    "assets/categories.png",
    "assets/store.png",
    "assets/lat_long.png",
    "assets/user.png",
    "assets/categories.png",
    "assets/store.png",
    "assets/lat_long.png",
  ];

  List<ProductsInfo> productInfo = [];

  @override
  Widget build(BuildContext context) {
    var inp1 = widget.outletInfo;
    var inp2 = widget.ownerInfo;
    debugPrint("passed input = $inp1");
    debugPrint("passed input = $inp2");
    return Scaffold(
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Text(names[index]);
        },
      ),
      bottomSheet: MaterialButton(
        height: 50,
        minWidth: MediaQuery.of(context).size.width,
        color: MColor.colorSecondary,
        textColor: Colors.white,
        onPressed: () async {
          // debugPrint("edit store userId ");
          // debugPrint("edit store ownerName ${txtOwnerNameController.text}");
          // debugPrint(
          //     "edit store primaryMobile ${txtPrimaryMobController.text}");
          // debugPrint(
          //     "edit store secondaryMobile ${txtSecondaryMobController.text}");
          // debugPrint("edit store helperMobile ${txtHelperMobController.text}");
          // debugPrint("edit store callTimeSlotId $callTimeSlotId");
          // debugPrint("edit store primaryLangId $primaryLangId");
          // debugPrint("edit store secondaryLangId $secondaryLangId");
          // debugPrint("edit store whatsAppMessage $whatsAppSmsRadio");
          // debugPrint("edit store panNo ${txtPANController.text}");
          // debugPrint("edit store aadhar ${txtAdharNumberController.text}");
          // debugPrint("edit store birthday ${txtPicDateController.text}");
          // debugPrint("edit store anniversary ${txtAnniversaryController.text}");
          // debugPrint("edit store ownerPhoto $ownerFileName");
          // Map<String, dynamic> ownerInfo = HashMap<String, dynamic>();
          // ownerInfo["owner_name"] = txtOwnerNameController.text;
          // ownerInfo["primary_mobile"] = txtPrimaryMobController.text;
          // ownerInfo["secondary_mobile"] = txtSecondaryMobController.text;
          // ownerInfo["helper_mobile"] = txtHelperMobController.text;
          // ownerInfo["call_time_slot"] = txtSelectCallTimeSlotController.text;
          // ownerInfo["lang_first"] = txtSelectLangFirstController.text;
          // ownerInfo["lang_second"] = txtSelectLangSecondController.text;
          // ownerInfo["whats_app_msg"] = whatsAppSmsRadio;
          // ownerInfo["pan_number"] = txtPANController.text;
          // ownerInfo["aadhar_number"] = txtAdharNumberController.text;
          // ownerInfo["birthday"] = txtPicDateController.text;
          // ownerInfo["anniversary"] = txtAnniversaryController.text;
          // ownerInfo["owner_photo"] = ownerPhotoFile;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              submitCaps,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.67,
              ),
            ),
            Image(
              width: 30,
              image: AssetImage("assets/arrow.png"),
            )
          ],
        ),
      ),
    );
  }

  List<Widget>? listWidget() {
    List<Widget> widgets = [];
    var text = const Text("Which category/brand does retailer keep?");
    widgets.add(text);
    for (ProductsInfo info in productInfo) {
      widgets.add(Row(
        children: [
          Image.asset(info.icons),
          const SizedBox(
            width: 10,
          ),
          Text(info.productName),
        ],
      ));
      return widgets;
    }
  }
}

class ProductsInfo {
  String icons;
  String productName;
  ProductsInfo({required this.icons, required this.productName});
}
