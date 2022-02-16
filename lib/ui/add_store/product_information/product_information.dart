import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class ProductInformation extends StatefulWidget {
  final Map<String, dynamic> outletInfo;
  final Map<String, dynamic> ownerInfo;

  const ProductInformation({Key? key, required this.outletInfo, required this.ownerInfo}) : super(key: key);

  @override
  State<ProductInformation> createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> {
  List<ProductsInfo> productInfo = [];

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemCount: productInfo.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          return ProductListItem(productsInfo: productInfo[index]);
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

  getProduct() async {
    for (int i = 0; i < 10; i++) {
      productInfo.add(ProductsInfo(
          icons: "https://dms-upload.s3.ap-southeast-1.amazonaws.com/apimenu_images/61cc431b22fbe.png",
          productName: "product$i",
          brands: [Brand(name: "brand1"), Brand(name: "brand2"), Brand(name: "brand3"), Brand(name: "brand4")]));
    }
    setState(() {});
  }
}

class ProductsInfo {
  String icons;
  String productName;
  bool check = false;
  List<Brand> brands;

  ProductsInfo({required this.icons, required this.productName, required this.brands});
}

class Brand {
  String name;
  bool check = false;

  Brand({required this.name});
}

class ProductListItem extends StatefulWidget {
  final ProductsInfo productsInfo;

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
              imageUrl: widget.productsInfo.icons,
              width: 30,
              height: 30,
            ),
            title: Text(
              widget.productsInfo.productName,
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
                  itemCount: widget.productsInfo.brands.length,
                  itemBuilder: (index) {
                    return ItemTags(
                      singleItem: false,
                      index: index,
                      elevation: 0,
                      pressEnabled: true,
                      onPressed: (item) {
                        widget.productsInfo.brands[index].check = item.customData.check;
                        setState(() {});
                      },
                      customData: widget.productsInfo.brands[index],
                      textStyle: const TextStyle(fontSize: 17),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      title: widget.productsInfo.brands[index].name,
                      active: widget.productsInfo.brands[index].check,
                      textActiveColor: MColor.activeTextColor,
                      textColor: MColor.inactiveTextColor,
                      color: MColor.disableBgColor,
                      activeColor: MColor.enableBgColor,
                      border: Border.all(
                          color: widget.productsInfo.brands[index].check ? MColor.enableBorderColor : MColor.disableBorderColor),
                    );
                  },
                )
              : Container()
        ],
      ),
    );
  }
}
