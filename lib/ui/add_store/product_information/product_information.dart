import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/main.dart';
import 'package:dms/model/get_survey_product.dart';
import 'package:dms/ui/bottom_sheet_widget/otp_bottom_sheet.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductInformation extends StatefulWidget {
  final Map<String, dynamic> outletInfo;
  final Map<String, dynamic> ownerInfo;

  const ProductInformation({Key? key, required this.outletInfo, required this.ownerInfo}) : super(key: key);

  @override
  State<ProductInformation> createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> {
  List<Widget> products = [];

  StreamController<List<Widget>> productStream = StreamController();
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    products.add(const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        "Which category/brand does retailer keep?",
        style: TextStyle(fontSize: 20, color: MColor.colorPrimary, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    ));

    productStream.add(products);
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.white24,
        title: const Text(
          productInformation,
          style: TextStyle(
            color: MColor.backButton,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: MColor.backButton,
          ),
        ),
      ),
      body: StreamBuilder<List<Widget>>(
        stream: productStream.stream,
        builder: (context, snapshot) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            itemCount: products.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              return products[index];
            },
          );
        },
      ),
      bottomNavigationBar: MaterialButton(
        height: 50,
        minWidth: MediaQuery.of(context).size.width,
        color: MColor.colorSecondary,
        textColor: Colors.white,
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              builder: (context) {
                return const SelectOtpNumberBottomSheet();
              });

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

  getProduct() async {
    GetSurveyProduct response = await repository.getSurveyProduct();

    if (response.success && response.data.isNotEmpty) {
      await Future.forEach(response.data, (SurveyProduct product) => products.add(ProductListItem(productsInfo: product)));

      debugPrint("products--->${products.length}");

      productStream.add(products);
    }
  }
}

class ProductListItem extends StatefulWidget {
  final SurveyProduct productsInfo;

  const ProductListItem({Key? key, required this.productsInfo}) : super(key: key);

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  bool checked = false;

  @override
  void initState() {
    checked = widget.productsInfo.check;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 0),
            leading: CachedNetworkImage(
              imageUrl: widget.productsInfo.categoryDescription,
              width: 30,
              height: 30,
            ),
            title: Text(
              widget.productsInfo.categoryName,
              style: const TextStyle(color: MColor.textColor, letterSpacing: 0.5, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: Checkbox(
              value: checked,
              onChanged: (value) {
                checked = value!;
                widget.productsInfo.check = value;
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: checked ? 10 : 0,
          ),
          checked
              ? Tags(
                  alignment: WrapAlignment.start,
                  itemCount: widget.productsInfo.brand.length,
                  itemBuilder: (index) {
                    return ItemTags(
                      singleItem: false,
                      index: index,
                      elevation: 0,
                      pressEnabled: true,
                      onPressed: (item) {
                        widget.productsInfo.brand[index].check = item.customData.check;
                        setState(() {});
                      },
                      customData: widget.productsInfo.brand[index],
                      textStyle: const TextStyle(fontSize: 17),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      title: widget.productsInfo.brand[index].brandName,
                      active: widget.productsInfo.brand[index].check,
                      textActiveColor: MColor.activeTextColor,
                      textColor: MColor.inactiveTextColor,
                      color: MColor.disableBgColor,
                      activeColor: MColor.enableBgColor,
                      border: Border.all(
                          color: widget.productsInfo.brand[index].check ? MColor.enableBorderColor : MColor.disableBorderColor),
                    );
                  },
                )
              : Container()
        ],
      ),
    );
  }
}
