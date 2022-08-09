import 'dart:async';
import 'dart:developer';

import 'package:dms/database/db_constant.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_booking_list/model/get_products_response.dart';
import 'package:dms/ui/order_booking/order_booking_list/product_list_item.dart';
import 'package:flutter/material.dart';

class OrderedProductList extends StatefulWidget {
  const OrderedProductList({Key? key}) : super(key: key);

  @override
  _OrderedProductListState createState() => _OrderedProductListState();
}

class _OrderedProductListState extends State<OrderedProductList> with AutomaticKeepAliveClientMixin {
  List<ProductsModal> products = [];
  StreamController<List<ProductsModal>> productStream = StreamController();

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<ProductsModal>>(
        stream: productStream.stream,
        builder: (context, snapshot) {
          log("snapshot-->$snapshot");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              "Product not found",
            ));
          }

          if (snapshot.hasData) {
            List<ProductsModal> products = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (context, index) {
                return ProductListItem(
                  products: products[index],
                );
              },
            );
          }

          return Container();
        });
  }

  void getProduct() async {
    List<Cart> cartList = await databaseHelper.getCart();
    if (cartList.isNotEmpty) {
      await Future.forEach(cartList, (Cart cart) {
        List<Scheme> schemeList = [];
        if (cart.scheme.isNotEmpty && cart.schemeId.isNotEmpty) {
          debugPrint("scheme-->${cart.scheme}");
          Scheme scheme = Scheme.fromJson(cart.scheme);
          schemeList.add(scheme);
          debugPrint("schemeName-->${scheme.schemeName}");
        }

        ProductsModal product = ProductsModal(
            id: cart.productId,
            productName: cart.productName,
            mrp: cart.mrp,
            schemeRatePerPcs: cart.schemeRatePerPcs,
            image: cart.productImage,
            skuRatePerPkg: cart.skuRatePerPkg,
            skuRatePerMoq: cart.skuRatePerMoq,
            skuRatePerPiece: cart.skuRatePerPiece,
            moqName: cart.moqName,
            moqId: cart.moqId,
            packagingName: cart.packagingName,
            packagingId: cart.packagingId,
            skuCode: cart.skuCode,
            weight: cart.weight,
            variantName: cart.variantName,
            variantId: cart.variantId,
            brandId: cart.brandId,
            brandName: cart.brandName,
            buId: cart.buId,
            categoryId: cart.categoryId,
            categoryName: cart.categoryName,
            rateCategoryId: cart.rateCategoryId,
            longDescription: cart.description,
            pcsPerMoq: cart.pcsPerMoq.toString(),
            pcsPerPackaging: cart.pcsPerPackaging.toString(),
            priceAfterDiscount: cart.priceAfterDiscount,
            customerId: cart.customerId,
            saleableStockPcs: "0",
            schemes: schemeList);
        products.add(product);
      });

      productStream.add(products);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
