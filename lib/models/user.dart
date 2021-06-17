import 'package:farreco/models/utils.dart';

//modelling users data
class Users {
  String name, village, mandal, district, pincode;
  String phoneNumber, uid;
  double landArea;
  FarmingType farmingType;
  Users(this.name, this.phoneNumber, this.village, this.mandal, this.district,
      this.pincode, this.landArea, this.uid, this.farmingType);
  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'address': {
          'village': village,
          'mandal': mandal,
          'district': district,
          'pincode': pincode
        },
        'landArea': landArea,
        'uid': uid,
        'farmingType': farmingType.toString()
      };
}
