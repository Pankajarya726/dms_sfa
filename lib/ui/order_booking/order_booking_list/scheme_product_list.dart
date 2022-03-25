import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/box_moq_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/scheme_product_info_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_booking_list/full_screen_image_view.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'model/get_products_response.dart';

class SchemeProductListItems extends StatefulWidget {
  final int index;
  final ProductsModal schemes;
  const SchemeProductListItems(
      {Key? key, required this.index, required this.schemes})
      : super(key: key);

  @override
  State<SchemeProductListItems> createState() => _SchemeProductListItemsState();
}

class _SchemeProductListItemsState extends State<SchemeProductListItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: widget.index == 0
            ? Colors.transparent
            : widget.index == 1
                ? const Color.fromRGBO(197, 181, 0, 1)
                : const Color.fromRGBO(44, 183, 67, 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                shape: bottomSheetShape,
                isScrollControlled: true,
                builder: (context) => SchemeProductInfoBottomSheet(
                      schemes: widget.schemes,
                    ));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenImageView(
                                  productImage: widget.schemes.image)),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          imageUrl: widget.schemes.image,
                          imageBuilder: (context, imageProvider) {
                            return Image(
                              image: imageProvider,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/placeholder.png"),
                          placeholder: (context, url) =>
                              Image.asset("assets/placeholder.png"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.only(top: 1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.schemes.productName,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                color: MColor.textColor,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "MRP: ",
                                    style: const TextStyle(
                                      letterSpacing: 0.67,
                                      color: MColor.textColor,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "₹" + widget.schemes.mrp,
                                        style: const TextStyle(
                                          letterSpacing: 0.67,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "PTR: ",
                                      style: const TextStyle(
                                        letterSpacing: 0.67,
                                        color: MColor.textColor,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "₹" + widget.schemes.ptr,
                                          style: const TextStyle(
                                            letterSpacing: 0.67,
                                            color: MColor.textColor,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textFields("BOX", context, "Packing"),
                                textFields("MOQ", context, "MOQ"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textFields(textLabel, BuildContext context, String sheetType) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        showModalBottomSheet(
            context: context,
            shape: bottomSheetShape,
            builder: (context) => BoxMoqSheet(
                  sheetHeding: textLabel,
                  sheetType: sheetType,
                ));
      },
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.red,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              textLabel,
              style: const TextStyle(
                color: MColor.colorPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.67,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: MColor.backButton,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class Flavours {
  String flavourName;
  String mrp;
  String ptr;

  String image;

  Flavours({
    required this.flavourName,
    required this.mrp,
    required this.ptr,
    required this.image,
  });
}
