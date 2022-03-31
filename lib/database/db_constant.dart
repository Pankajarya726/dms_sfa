class DBConstant {
  static const dbName = "dms.db";
  static const cartTable = "cart_table";

  static const id = "id";
  static const productName = "product_name";
  static const productId = "product_id";
  static const productImage = "product_image";
  static const customerId = "customer_id";
  static const brandName = "brand_name";
  static const brandId = "brand_id";
  static const buId = "bu_id";
  static const ptr = "ptr";
  static const mrp = "mrp";
  static const skuRatePerPkg = "sku_rate_per_pkg";
  static const skuRatePerMoq = "sku_rate_per_moq";
  static const skuRatePerPiece = "sku_rate_per_piece";
  static const pcsPerPackaging = "pcs_per_packaging";
  static const priceAfterDiscount = "price_after_discount";
  static const pcsPerMoq = "pcs_per_moq";
  static const moqName = "moq_name";
  static const moqId = "moq_id";
  static const packagingName = "packaging_name";
  static const packagingId = "packaging_id";
  static const variantName = "variant_name";
  static const variantId = "variant_id";
  static const skuCode = "sku_code";
  static const weight = "weight";
  static const moqQty = "moq_qty";
  static const pkgOty = "pkg_qty";
  static const description = "description";

  //crate table query
  static const String createCartTable = "CREATE TABLE " +
      cartTable +
      "(" +
      id +
      " INTEGER PRIMARY KEY AUTOINCREMENT , " +
      productId +
      " TEXT," +
      productName +
      " TEXT," +
      productImage +
      " TEXT," +
      customerId +
      " TEXT," +
      brandName +
      " TEXT," +
      brandId +
      " TEXT," +
      buId +
      " TEXT," +
      ptr +
      " TEXT," +
      mrp +
      " TEXT," +
      skuRatePerPkg +
      " TEXT," +
      weight +
      " TEXT," +
      skuRatePerMoq +
      " TEXT," +
      skuRatePerPiece +
      " TEXT," +
      pcsPerPackaging +
      " INTEGER," +
      priceAfterDiscount +
      " TEXT," +
      pcsPerMoq +
      " INTEGER," +
      moqName +
      " TEXT," +
      moqId +
      " TEXT," +
      packagingName +
      " TEXT," +
      packagingId +
      " TEXT," +
      variantName +
      " TEXT," +
      variantId +
      " TEXT," +
      skuCode +
      " TEXT," +
      moqQty +
      " INTEGER," +
      pkgOty +
      " INTEGER," +
      description +
      " TEXT )";
}

class Cart {
  String productName = "";
  String productId = "";
  String productImage = "";
  String customerId = "";
  String brandName = "";
  String brandId = "";
  String buId = "";
  String ptr = "0.0";
  String mrp = "0.0";
  String skuRatePerPkg = "0.0";
  String skuRatePerMoq = "0.0";
  String skuRatePerPiece = "0.0";
  int pcsPerPackaging = 0;
  String priceAfterDiscount = "0.0";
  int pcsPerMoq = 0;
  String moqName = "";
  String moqId = "";
  String packagingName = "";
  String packagingId = "";
  String variantName = "";
  String variantId = "";
  String skuCode = "";
  String weight = "0";
  String description = "";
  int moqQty = 0;
  int pkgOty = 0;

  Cart(
      {required this.productName,
      required this.productId,
      required this.productImage,
      required this.customerId,
      required this.brandName,
      required this.brandId,
      required this.buId,
      required this.ptr,
      required this.mrp,
      required this.skuRatePerPkg,
      required this.skuRatePerMoq,
      required this.skuRatePerPiece,
      required this.pcsPerPackaging,
      required this.priceAfterDiscount,
      required this.pcsPerMoq,
      required this.moqName,
      required this.moqId,
      required this.packagingName,
      required this.packagingId,
      required this.variantName,
      required this.variantId,
      required this.skuCode,
      required this.weight,
      required this.description,
      required this.moqQty,
      required this.pkgOty});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "product_name": productName,
      "product_id": productId,
      "product_image": productImage,
      "customer_id": customerId,
      "brand_name": brandName,
      "brand_id": brandId,
      "bu_id": buId,
      "ptr": ptr,
      "mrp": mrp,
      "sku_rate_per_pkg": skuRatePerPkg,
      "sku_rate_per_moq": skuRatePerMoq,
      "sku_rate_per_piece": skuRatePerPiece,
      "pcs_per_packaging": pcsPerPackaging,
      "price_after_discount": priceAfterDiscount,
      "pcs_per_moq": pcsPerMoq,
      "moq_name": moqName,
      "moq_id": moqId,
      "packaging_name": packagingName,
      "packaging_id": packagingId,
      "variant_name": variantName,
      "variant_id": variantId,
      "sku_code": skuCode,
      "weight": weight,
      "moq_qty": moqQty,
      "pkg_qty": pkgOty,
      "description": description,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        productName: json["product_name"],
        productImage: json['product_image'],
        productId: json["product_id"],
        customerId: json["customer_id"],
        brandName: json["brand_name"],
        brandId: json["brand_id"],
        buId: json["bu_id"],
        ptr: json["ptr"],
        mrp: json["mrp"],
        skuRatePerPkg: json["sku_rate_per_pkg"],
        skuRatePerMoq: json["sku_rate_per_moq"],
        skuRatePerPiece: json["sku_rate_per_piece"],
        pcsPerPackaging: json["pcs_per_packaging"],
        priceAfterDiscount: json["price_after_discount"],
        pcsPerMoq: json["pcs_per_moq"],
        moqName: json["moq_name"],
        moqId: json['moq_id'],
        packagingName: json["packaging_name"],
        packagingId: json['packaging_id'],
        variantName: json["variant_name"],
        variantId: json['variant_id'],
        skuCode: json["sku_code"],
        weight: json["weight"],
        moqQty: json["moq_qty"],
        pkgOty: json["pkg_qty"],
        description: json["description"],
      );
}

class BrandWiseCart {
  String brandId;
  String brandName;
  String moqTotal;
  String pkgTotal;
  String total;
  List<Cart> cartList;

  BrandWiseCart(
      {required this.brandId,
      required this.cartList,
      required this.total,
      required this.moqTotal,
      required this.pkgTotal,
      required this.brandName});

  factory BrandWiseCart.fromMap(Map<String, dynamic> json) => BrandWiseCart(
        brandId: json["brand_id"],
        brandName: json["brand_name"],
        moqTotal: json["total_moq_qty"],
        pkgTotal: json["total_pkg_qty"],
        total: json["total_amount"],
        cartList: json["cart"] == null ? [] : List<Cart>.from(json["cart"].map((x) => Cart.fromMap(x))),
      );
}
