import 'package:dio/dio.dart';
import 'package:dms/model/get_survey_product.dart';
import 'package:dms/ui/add_store/model/call_time_slot_response.dart';
import 'package:dms/ui/add_store/model/select_language_response.dart';
import 'package:path/path.dart' as path;

class RetailerForm {
  String enrollmentTypeId = "";
  String enrollmentType = "";
  String districtId = "";
  String district = "";
  String distributor = "";
  String distributorId = "";
  String beatName = "";
  String beatId = "";
  String orderBookingDay1 = "";
  String orderBookingDay2 = "";
  String outletName = "";
  String outletCloseTime = "";
  String latitude = "";
  String longitude = "";
  String address = "";
  String pinCode = "";
  String landmark = "";
  String cityName = "";
  String isExistingRetailer = "0";
  String retailerType = "";
  String retailerTypeId = "";
  String retailerCategory = "";
  String retailerCategoryId = "";
  String isKro = "0";
  String gstNo = "";
  String outletImage = "";
  String ownerName = "";
  String primaryMobile = "";
  String secondaryMobile = "";
  String helperMobile = "";
  String priceCategory = "";

  CallTimeSlotModel? callTimeSlot;
  LanguageModel? primaryLang;
  LanguageModel? secondaryLang;

  String isWhatsappSms = "";
  String pan = "";
  String aadhaarNumber = "";
  String birthday = "";
  String anniversary = "";
  String ownerImage = "";
  String email = "";
  String cityId = "";

  String streetName = "";
  String street = "";
  String countryCode = "";
  String country = "";
  String postalCode = "";
  String administrativeArea = "";
  String subAdministrativeArea = "";
  String locality = "";
  String subLocality = "";
  String thoroughfare = "";
  String subThoroughfare = "";
  bool checkMobileNumber = false;

  Map<String, dynamic> category = {};

  List<SurveyProduct> productList = [];

  RetailerForm();

  FormData toFormData() {
    return FormData.fromMap(toMap());
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "owner_name": ownerName,
        "email": email,
        "mobile_number": primaryMobile,
        "helper_mobile": helperMobile,
        "district_id": districtId,
        "pan": pan,
        "adhar_number": aadhaarNumber,
        "birthday": birthday,
        "owner_image": ownerImage.isEmpty ? null : MultipartFile.fromFileSync(ownerImage, filename: path.basename(ownerImage)),
        "outlet_image": outletImage.isEmpty ? null : MultipartFile.fromFileSync(outletImage, filename: path.basename(outletImage)),
        "anniversary": anniversary,
        "outlet_name": outletName,
        "outlet_close_time": outletCloseTime,
        "beat_name": beatId,
        "distributor": distributorId,
        "latitude": latitude,
        "longitude": longitude,
        "secondary_mobile": secondaryMobile,
        "address": address,
        "landmark": landmark,
        "pincode": pinCode,
        "city_name": cityName,
        "is_kro": isKro,
        "gst_no": gstNo,
        "is_existing_retailer": isExistingRetailer,
        "enrollment_type_id": enrollmentTypeId,
        "call_time_slot_id": callTimeSlot == null ? "" : callTimeSlot!.id,
        "language_id_1": primaryLang == null ? "" : primaryLang!.id,
        "language_id_2": secondaryLang == null ? "" : secondaryLang!.id,
        "retailer_type": retailerTypeId,
        "retailer_category": retailerCategoryId,
        "is_whatsapp_sms": isWhatsappSms,
        "order_booking_day_1": orderBookingDay1,
        "order_booking_day_2": orderBookingDay2,
        "street_name": streetName,
        "street": street,
        "country_code": countryCode,
        "country": country,
        "postal_code": postalCode,
        "administrative_area": administrativeArea,
        "subadministrative_area": subAdministrativeArea,
        "locality": locality,
        "sublocality": subLocality,
        "thoroughfare": thoroughfare,
        "subthoroughfare": subThoroughfare,
        "price_category": priceCategory,
      };
}
