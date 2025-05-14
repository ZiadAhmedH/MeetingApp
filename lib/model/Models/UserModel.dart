class UserModel{
  final  String uid;
 final String userName;
 final String email;
 final String? profileImage;
final  String phone;
 final String location;
final  String jobTitle;
  
  UserModel({
   required this.uid,
   required this.userName,
  required  this.email,
  required  this.profileImage,
  required  this.phone,
  required  this.location,
  required  this.jobTitle,
  });
  
  UserModel.fromJason(Map<String, dynamic> json)
      : userName = json["UserName"],
        email = json["Email"],
        profileImage = json["profileImage"],
        uid = json["uid"],
        phone = json["phone"],
        location = json["Location"],
        jobTitle = json["JobTitle"];


}