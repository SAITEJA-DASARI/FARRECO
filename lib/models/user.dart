//modelling users data
class Users {
  String name, village, mandal, district, pincode;
  String phoneNumber, uid;
  double landArea;
  Users(this.name, this.phoneNumber, this.village, this.mandal, this.district,
      this.pincode, this.landArea, this.uid);
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
        'uid': uid
      };
}
