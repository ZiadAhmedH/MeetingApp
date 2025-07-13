class UserModel{
  final  String uid;
 final String userName;
 final String email;
 final String? profileImage;
final  String phone;
 final String location;
final  String jobTitle;
final bool isOnline;
final String? lastSeen;
  
  UserModel({
   required this.uid,
   required this.userName,
  required  this.email,
  required  this.profileImage,
  required  this.phone,
  required  this.location,
  required  this.jobTitle,
  required this.isOnline,
  required this.lastSeen,
  });
  
 UserModel.fromJson(Map<String, dynamic> json)
    : userName = json["username"],
      email = json["email"],
      profileImage = json["profile_image"],
      uid = json["id"],
      phone = json["phone"],
      location = json["location"],
      jobTitle = json["job_title"],
      isOnline = json["is_online"] ?? false,
      lastSeen = json["last_seen"];

      
  Map<String, dynamic> toJson() {
    return {
      "username": userName,
      "email": email,
      "profile_image": profileImage,
      "id": uid,
      "phone": phone,
      "location": location,
      "job_title": jobTitle,
      "is_online": isOnline,
      "last_seen": lastSeen,
    };
  }
}