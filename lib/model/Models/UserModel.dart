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
  
 UserModel.fromJson(Map<String, dynamic> json)
    : userName = json["username"],
      email = json["email"],
      profileImage = json["profile_image"],
      uid = json["id"],
      phone = json["phone"],
      location = json["location"],
      jobTitle = json["job_title"];



}