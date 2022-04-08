import 'dart:async';

import 'package:dms/database/db_constant.dart';
import 'package:dms/main.dart';
import 'package:dms/ui/order_booking/order_details/bloc/order_detail_event.dart';
import 'package:dms/ui/order_booking/order_details/bloc/order_detail_state.dart';
import 'package:dms/ui/order_booking/order_details/model/get_order_response.dart';
import 'package:dms/utils/constants.dart';
import 'package:dms/utils/network.dart';
import 'package:dms/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  OrderDetailBloc() : super(OrderDetailInitialState());

  Stream<OrderDetailState> getOrder(GetOrderEvent event) async* {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {
        "retailer_id": event.retailerId,
      };
      GetOrderResponse response = await repository.getOrder(input);
      if (response.success) {
        if (response.data.isNotEmpty && response.orders.isNotEmpty) {
          yield* saveOrderToCart(
              orders: response.orders.first, products: response.data, task: response.task.isNotEmpty ? response.task.first : null);
        } else {
          yield GetOrderFailureState(msg: "Could not fetch order detal");
        }
      } else {
        yield GetOrderFailureState(msg: response.message);
      }
    } else {
      Utility.showToast(Constants.internetAlert);
    }
  }

  Stream<OrderDetailState> saveOrderToCart({required Order orders, required List<Product> products, Task? task}) async* {
    await Future.forEach(products, (Product product) async {
      Cart cart = Cart(
          productName: product.productName,
          productId: product.orderSkuId,
          productImage: product.image,
          customerId: product.customerId,
          brandName: product.brandName,
          brandId: product.brandId,
          buId: product.buId,
          schemeRatePerPcs: product.schemeRatePerPcs,
          mrp: product.mrp,
          skuRatePerPkg: product.skuRatePerPkg,
          skuRatePerMoq: product.skuRatePerMoq,
          skuRatePerPiece: product.skuRatePerPiece,
          pcsPerPackaging: product.pcsPerPackaging,
          priceAfterDiscount: product.priceAfterDiscount,
          pcsPerMoq: product.pcsPerMoq,
          moqName: product.moqName,
          moqId: product.moqId,
          packagingName: product.packagingName,
          packagingId: product.packagingId,
          variantName: product.variantName,
          variantId: product.variantId,
          rateCategoryId: product.rateCategoryId,
          categoryId: product.categoryId,
          categoryName: product.categoryName,
          schemeId: product.schemes.isEmpty ? "" : product.schemes.first.id,
          schemeOn: product.schemes.isEmpty ? "" : product.schemes.first.uom,
          skuCode: product.skuCode,
          weight: product.weight,
          description: product.longDescription,
          moqQty: product.orderQtyMoq,
          scheme: product.schemes.isEmpty ? "" : product.schemes.first.toJson(),
          totalPrice: product.orderSkuAmount,
          pkgOty: product.orderQtyPkg);
      int updated = await databaseHelper.addProductToCart(cart);
      debugPrint("update-->$updated");
    });

    yield GetOrderSuccessState(orders: orders, products: products, task: task);
  }

  @override
  Stream<OrderDetailState> mapEventToState(OrderDetailEvent event) async* {
    if (event is GetOrderEvent) {
      yield* getOrder(event);
    }
  }
}
