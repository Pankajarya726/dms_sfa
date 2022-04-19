import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';

class RetailerNotFound extends StatelessWidget {
  final Function onRefresh;
  const RetailerNotFound({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/svg/no_retailer_found.png",
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.60,
          height: MediaQuery.of(context).size.width * 0.60,
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "No Retailer Found",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: const Text(
            "There is no retailer at the moment please refresh the page.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff555555), fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        MaterialButton(
          onPressed: () {
            onRefresh();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: MColor.colorPrimary,
          child: const Text(
            "Refresh",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.5, fontSize: 16),
          ),
        )
      ],
    );
  }
}

class ProductNotFound extends StatelessWidget {
  final Function onRefresh;
  const ProductNotFound({Key? key, required this.onRefresh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/svg/no_product_found.png",
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.60,
          height: MediaQuery.of(context).size.width * 0.60,
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "No Product Found",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: const Text(
            "There is no product at the moment please refresh the page.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff555555), fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        MaterialButton(
          onPressed: () {
            onRefresh();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: MColor.colorPrimary,
          child: const Text(
            "Refresh",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.5, fontSize: 16),
          ),
        )
      ],
    );
  }
}
