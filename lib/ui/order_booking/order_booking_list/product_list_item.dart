import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/database/db_constant.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:dms/ui/bottom_sheet_widget/box_moq_bottom_sheet.dart';
import 'package:dms/ui/bottom_sheet_widget/product_info_bottom_sheet.dart';
import 'package:dms/ui/order_booking/order_booking_list/full_screen_image_view.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatefulWidget {
  final ProductsModal products;

  const ProductListItem({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  int moqQty = 0;
  int pkgQty = 0;

  @override
  void initState() {
    debugPrint("ProductListItem---initState-->");
    fetchProductFromCart();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    debugPrint("ProductListItem---didChangeDependencies-->");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ProductListItem oldWidget) {
    debugPrint("ProductListItem---didUpdateWidget-->");
    fetchProductFromCart();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("${int.parse(widget.products.pcsPerPackaging) ~/ int.parse(widget.products.pcsPerMoq)}");
    debugPrint("${int.parse(widget.products.pcsPerPackaging) / int.parse(widget.products.pcsPerMoq)}");
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: pkgQty == 0 && moqQty == 0 ? Colors.white : const Color.fromRGBO(44, 183, 67, 1),
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
                builder: (context) => ProductInfoBottomSheet(
                      products: widget.products,
                    ));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullScreenImageView(productImage: widget.products.image)),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          imageUrl: widget.products.image,
                          imageBuilder: (context, imageProvider) {
                            return Image(
                              image: imageProvider,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                          errorWidget: (context, url, _) {
                            return Image.asset(
                              "assets/wall_placeholder.jpg",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                          placeholder: (context, url) {
                            return Image.asset(
                              "assets/wall_placeholder.jpg",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.products.productName,
                              style: const TextStyle(
                                letterSpacing: 0.67,
                                color: MColor.textColor,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            /*  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        text: currencyFormat
                                            .format(double.parse(widget.products.mrp)),
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
                                          text: currencyFormat.format(double.parse(widget.products.skuRatePerPiece)),
                                          style: TextStyle(
                                              letterSpacing: 0.67,
                                              color: MColor.textColor,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              decoration: double.parse(widget.products.schemeRatePerPcs) == 0.0
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough),
                                        ),
                                        TextSpan(
                                          text: double.parse(widget.products.schemeRatePerPcs) == 0.0
                                              ? ""
                                              : currencyFormat.format(double.parse(widget.products.schemeRatePerPcs)),
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
                            ),*/
                            RichText(
                              text: TextSpan(
                                text: "MRP: ",
                                style: const TextStyle(
                                  letterSpacing: 0.67,
                                  color: MColor.textColor,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: currencyFormat.format(double.parse(widget.products.mrp)),
                                    style: const TextStyle(
                                      letterSpacing: 0.67,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " | ",
                                    style: TextStyle(
                                      letterSpacing: 0.67,
                                      color: MColor.colorPrimary,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  TextSpan(
                                    text: currencyFormat
                                        .format(double.parse(widget.products.mrp) * double.parse(widget.products.pcsPerMoq)),
                                    style: const TextStyle(
                                      letterSpacing: 0.67,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "PTR: ",
                                style: const TextStyle(
                                  letterSpacing: 0.67,
                                  color: MColor.textColor,
                                ),
                                children: <TextSpan>[
                                  TextSpan(children: [
                                    TextSpan(
                                      text: currencyFormat.format(double.parse(widget.products.skuRatePerPiece)),
                                      style: TextStyle(
                                          letterSpacing: 0.67,
                                          color: MColor.textColor,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          decoration: double.parse(widget.products.schemeRatePerPcs) == 0.0
                                              ? TextDecoration.none
                                              : TextDecoration.lineThrough),
                                    ),
                                    TextSpan(
                                      text: double.parse(widget.products.schemeRatePerPcs) == 0.0
                                          ? ""
                                          : currencyFormat.format(double.parse(widget.products.schemeRatePerPcs)),
                                      style: const TextStyle(
                                        letterSpacing: 0.67,
                                        color: MColor.textColor,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                  TextSpan(
                                    text: " | ",
                                    style: TextStyle(
                                        letterSpacing: 0.67,
                                        color: MColor.textColor,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        decoration: double.parse(widget.products.schemeRatePerPcs) == 0.0
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough),
                                  ),
                                  TextSpan(children: [
                                    TextSpan(
                                      text: currencyFormat.format(double.parse(widget.products.skuRatePerMoq)),
                                      style: TextStyle(
                                          letterSpacing: 0.67,
                                          color: MColor.textColor,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          decoration: double.parse(widget.products.schemeRatePerPcs) == 0.0
                                              ? TextDecoration.none
                                              : TextDecoration.lineThrough),
                                    ),
                                    TextSpan(
                                      text: double.parse(widget.products.schemeRatePerPcs) == 0.0
                                          ? ""
                                          : currencyFormat.format(double.parse(widget.products.schemeRatePerPcs) *
                                              double.parse(widget.products.pcsPerMoq)),
                                      style: const TextStyle(
                                        letterSpacing: 0.67,
                                        color: MColor.textColor,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PkgWidget(
                                  name: widget.products.packagingName,
                                  qty: pkgQty,
                                  maxQty: 9,
                                  productId: widget.products.id,
                                  onChange: (int qty) {
                                    updateQty(pkgQty: qty, moqQty: widget.products.moqQty);
                                  },
                                ),
                                PkgWidget(
                                  name: widget.products.moqName,
                                  qty: moqQty,
                                  maxQty: int.parse(widget.products.pcsPerPackaging) ~/ int.parse(widget.products.pcsPerMoq) - 1,
                                  productId: widget.products.id,
                                  onChange: (int qty) {
                                    updateQty(pkgQty: widget.products.pkgQty, moqQty: qty);
                                  },
                                ),
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

  void fetchProductFromCart() async {
    Cart? cart = await databaseHelper.searchProductFromCart(widget.products.id);

    if (cart != null) {
      pkgQty = cart.pkgOty;
      moqQty = cart.moqQty;
      widget.products.pkgQty = cart.pkgOty;
      widget.products.moqQty = cart.moqQty;

      debugPrint("scheme--->${cart.scheme}");

      setState(() {});
    }
  }

  void updateQty({required int pkgQty, required int moqQty}) async {
    widget.products.pkgQty = pkgQty;
    widget.products.moqQty = moqQty;
    this.pkgQty = pkgQty;
    this.moqQty = moqQty;

    double total = 0;
    if (widget.products.schemes.isEmpty) {
      total = (double.parse(widget.products.skuRatePerMoq) * moqQty) + (double.parse(widget.products.skuRatePerPkg) * pkgQty);
    } else {
      total = (double.parse(widget.products.schemeRatePerPcs) * double.parse(widget.products.pcsPerMoq) * moqQty) +
          (double.parse(widget.products.schemeRatePerPcs) * double.parse(widget.products.pcsPerPackaging) * pkgQty);
    }

    Cart cart = Cart(
        packagingId: widget.products.packagingId,
        moqId: widget.products.moqId,
        variantId: widget.products.variantId,
        mrp: widget.products.mrp,
        skuRatePerMoq: widget.products.skuRatePerMoq,
        weight: widget.products.weight,
        schemeRatePerPcs: widget.products.schemeRatePerPcs,
        moqQty: moqQty,
        productName: widget.products.productName,
        skuCode: widget.products.skuCode,
        variantName: widget.products.variantName,
        productImage: widget.products.image,
        buId: widget.products.buId,
        skuRatePerPiece: widget.products.skuRatePerPiece,
        productId: widget.products.id,
        brandId: widget.products.brandId,
        pcsPerMoq: int.parse(widget.products.pcsPerMoq),
        pcsPerPackaging: int.parse(widget.products.pcsPerPackaging),
        pkgOty: pkgQty,
        categoryId: widget.products.categoryId,
        categoryName: widget.products.categoryName,
        rateCategoryId: widget.products.rateCategoryId,
        schemeId: widget.products.schemes.isEmpty ? "" : widget.products.schemes.first.id,
        schemeOn: widget.products.schemes.isEmpty ? "" : widget.products.schemes.first.uom,
        brandName: widget.products.brandName,
        customerId: widget.products.customerId,
        skuRatePerPkg: widget.products.skuRatePerPkg,
        description: widget.products.longDescription,
        moqName: widget.products.moqName,
        priceAfterDiscount: widget.products.priceAfterDiscount,
        packagingName: widget.products.packagingName,
        scheme: widget.products.schemes.isEmpty ? "" : widget.products.schemes.first.toJson(),
        totalPrice: total.toStringAsFixed(2));

    int updated;
    if (pkgQty == 0 && moqQty == 0) {
      updated = await databaseHelper.deleteProductFromCart(cart.productId);
    } else {
      updated = await databaseHelper.addProductToCart(cart);
    }

    debugPrint("update-->$updated");
    setState(() {});
  }
}

class PkgWidget extends StatefulWidget {
  final int qty;
  final String name;
  final Function(int qty) onChange;
  final String productId;
  final int maxQty;

  const PkgWidget(
      {Key? key, required this.qty, required this.name, required this.onChange, required this.productId, required this.maxQty})
      : super(key: key);

  @override
  _PkgWidgetState createState() => _PkgWidgetState();
}

class _PkgWidgetState extends State<PkgWidget> {
  int qty = 0;

  @override
  void initState() {
    super.initState();
    qty = widget.qty;
    debugPrint("PkgWidget---initState-->$qty");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        showModalBottomSheet(
            context: context,
            shape: bottomSheetShape,
            builder: (context) => BoxMoqSheet(
                  selected: qty,
                  sheetHeading: widget.name,
                  sheetType: widget.name,
                  onSelect: (int i) {
                    qty = i;
                    widget.onChange(qty);
                    setState(() {});
                  },
                  maxQty: widget.maxQty,
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
              qty == 0 ? widget.name : qty.toString(),
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

  @override
  void didChangeDependencies() {
    debugPrint("PkgWidget---didChangeDependencies-->");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PkgWidget oldWidget) {
    debugPrint("PkgWidget---didUpdateWidget-->${widget.qty}");
    qty = widget.qty;
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }
}
