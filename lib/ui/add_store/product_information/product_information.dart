import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/main.dart';
import 'package:dms/model/base_response.dart';
import 'package:dms/model/get_survey_product.dart';
import 'package:dms/model/retailer_form.dart';
import 'package:dms/ui/bottom_sheet_widget/otp_bottom_sheet.dart';
import 'package:dms/ui/drawer_screen/drawer_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/string_const.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductInformation extends StatefulWidget {
  final RetailerForm form;
  const ProductInformation({
    Key? key,
    required this.form,
  }) : super(key: key);

  @override
  State<ProductInformation> createState() => _ProductInformationState();
}

class _ProductInformationState extends State<ProductInformation> {
  List<Widget> widgetList = [];
  List<SurveyProduct> productList = [];
  StreamController<List<Widget>> productStream = StreamController();
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    widgetList.add(const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        "Which category/brand does retailer keep?",
        style: TextStyle(
            fontSize: 20,
            color: MColor.colorPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5),
      ),
    ));
    productStream.add(widgetList);
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
          StringConst.productInformation,
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
            itemCount: widgetList.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              return widgetList[index];
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
          register(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              StringConst.submitCaps,
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
      productList.clear();
      productList.addAll(response.data);
      await Future.forEach(
          productList,
          (SurveyProduct product) =>
              widgetList.add(ProductListItem(productsInfo: product)));
      debugPrint("products--->${productList.length}");
      productStream.add(widgetList);
    }
  }

  void register(BuildContext context) async {
    List<SurveyProduct> selected =
        productList.where((element) => element.check).toList();
    debugPrint("selectedProduct--->$selected");
    if (selected.isEmpty) {
      Utility.showToast("Please select at least one Product");
      return;
    }

    List<Map<String, dynamic>> categoryList = [];

    selected.forEach((element) async {
      Map<String, dynamic> category = {};
      category["product_id"] = element.id;
      String brand = "";
      List<Brand> brands =
          element.brand.where((element) => element.check).toList();
      debugPrint("brands-->$brands");
      for (int i = 0; i < brands.length; i++) {
        if (i + 1 == brands.length) {
          brand = brand + "${brands[i].id}";
        } else {
          brand = brand + "${brands[i].id},";
        }
      }
      category["brands"] = brand;

      categoryList.add(category);
    });

    debugPrint("productMap-->$categoryList");
    debugPrint("productMap-->${jsonEncode(categoryList)}");

    Map<String, dynamic> input = widget.form.toMap();
    input["products"] = jsonEncode(categoryList);
    log("inputs--->" + input.toString());

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) {
          return SelectOtpNumberBottomSheet(
            form: widget.form,
            onDone: (String number) {
              debugPrint("otp_number-->$number");
              input["otp_number"] = number;
              try {
                log("inputs--->$input");
                registerApi(input);
              } catch (exception) {
                debugPrint("exception-->$exception");
              }
            },
            onSubmit: () {
              try {
                log("inputs--->$input");
                registerApi(input);
              } catch (exception) {
                debugPrint("exception-->$exception");
              }
            },
          );
        });
  }

  void registerApi(Map<String, dynamic> input) async {
    if (await Network.isConnected()) {
      EasyLoading.show();
      BaseResponse response = await repository.registerRetailer(input);
      EasyLoading.dismiss();

      if (response.success) {
        if (input["otp_number"].toString().isEmpty) {
          Utility.showToast(response.message);
          debugPrint(Navigator.defaultRouteName);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DrawerScreen()),
              (route) => false);
        } else {
          showVerifyOtpAlert(input["otp_number"]);
        }
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  void showVerifyOtpAlert(String mobile) async {
    showDialog(
        context: navigationService.navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: const Text(
              "Please Enter OTP",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            content: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.black, fontSize: 16, letterSpacing: 0.5),
                  )),
              TextButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) {
                      Utility.showToast("Please enter otp");
                    } else {
                      verifyOtp(mobile, controller.text.trim());
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                        color: MColor.colorPrimary,
                        fontSize: 16,
                        letterSpacing: 0.5),
                  )),
            ],
          );
        });
  }

  void verifyOtp(String mobile, String otp) async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {};
      input["otp_number"] = mobile;
      input["otp"] = otp;

      EasyLoading.show();
      BaseResponse response = await repository.verifyOtp(input);
      EasyLoading.dismiss();

      if (response.success) {
        Utility.showToast(response.message);
        debugPrint(Navigator.defaultRouteName);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DrawerScreen()),
            (route) => false);
      } else {
        Utility.showToast(response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }
}

class ProductListItem extends StatefulWidget {
  final SurveyProduct productsInfo;

  const ProductListItem({Key? key, required this.productsInfo})
      : super(key: key);

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
              imageUrl: widget.productsInfo.categoryImage != ""
                  ? widget.productsInfo.categoryImage
                  : "https://dms-upload.s3.ap-southeast-1.amazonaws.com/apimenu_images/61cc431b22fbe.png",
              width: 30,
              height: 30,
            ),
            title: Text(
              widget.productsInfo.categoryName,
              style: const TextStyle(
                  color: MColor.textColor,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
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
            height: checked && widget.productsInfo.brand.isNotEmpty ? 10 : 0,
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
                        widget.productsInfo.brand[index].check =
                            !item.customData.check;
                        setState(() {});
                      },
                      customData: widget.productsInfo.brand[index],
                      textStyle: const TextStyle(fontSize: 17),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      title: widget.productsInfo.brand[index].brandName,
                      active: widget.productsInfo.brand[index].check,
                      textActiveColor: MColor.activeTextColor,
                      textColor: MColor.inactiveTextColor,
                      color: MColor.disableBgColor,
                      activeColor: MColor.enableBgColor,
                      border: Border.all(
                          color: widget.productsInfo.brand[index].check
                              ? MColor.enableBorderColor
                              : MColor.disableBorderColor),
                    );
                  },
                )
              : Container()
        ],
      ),
    );
  }
}
