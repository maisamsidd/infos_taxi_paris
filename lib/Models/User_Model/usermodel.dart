class UserModel {
  String? fullname;
  String? email;
  String? uid;
  String? profilePic; 
  String? phoneNumber;

  UserModel({
    this.fullname,
    this.email,
    this.uid,
    this.profilePic,
    this.phoneNumber,
  });

  UserModel.frommap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    fullname = map['fullname'];
    profilePic = map['profilePic'];
    phoneNumber = map['phoneNumber'];
  }

  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,

    };
  }
}
