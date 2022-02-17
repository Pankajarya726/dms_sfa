import 'package:dio/dio.dart';
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
  String outletName = "";
  String latitude = "";
  String longitude = "";
  String address = "";
  String pinCode = "";
  String landmark = "";
  String isExistingRetailer = "0";
  String retailerType = "";
  String retailerTypeId = "";
  String retailerCategory = "";
  String retailerCategoryId = "";
  String isKro = "0";
  String gstNo = "";
  String outletImage = "";
  String ownerName = "";
  String mobileNumber = " ";
  String secondaryMobile = "";
  String helperNumber = "";
  String callTimeSlotId = "";
  String callTimeSlot = "";
  String languageId1 = "";
  String language1 = "";
  String language2 = "";
  String languageId2 = "";
  String isWhatsappSms = "";
  String pan = "";
  String aadhaarNumber = "";
  String birthday = "";
  String anniversary = "";
  String ownerImage = "";
  String email = "";
  String cityId = "";

  RetailerForm();

  FormData toFormData() {
    return FormData.fromMap(toMap());
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "owner_name": ownerName,
        "email": email,
        "mobile_number": mobileNumber,
        "helper_number": helperNumber,
        "city_id": districtId,
        "pan": pan,
        "adhar_number": aadhaarNumber,
        "birthday": birthday,
        "owner_image": ownerImage.isEmpty ? null : MultipartFile.fromFileSync(ownerImage, filename: path.basename(ownerImage)),
        "outlet_image": outletImage.isEmpty ? null : MultipartFile.fromFileSync(outletImage, filename: path.basename(outletImage)),
        "anniversary": anniversary,
        "outlet_name": outletName,
        "beat_name": beatId,
        "distributor": distributorId,
        "latitude": latitude,
        "longitude": longitude,
        "secondary_mobile": secondaryMobile,
        "address": address,
        "landmark": landmark,
        "pincode": pinCode,
        "is_kro": isKro,
        "gst_no": gstNo,
        "is_existing_retailer": isExistingRetailer,
        "enrollment_type_id": enrollmentTypeId,
        "call_time_slot_id": callTimeSlotId,
        "language_id_1": languageId1,
        "language_id_2": languageId2,
        "retailer_type": retailerTypeId,
        "retailer_category": retailerCategory,
        "is_whatsapp_sms": isWhatsappSms,
        "order_booking_day_1": orderBookingDay1
      };
}
