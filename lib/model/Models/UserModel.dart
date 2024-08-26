class UserModel
{
  String? userName;
  String? email;
  String? profileImage;
  String? uid;
  String? phone;
  String? location;
  String? jobTitle;

  UserModel({this.userName, this.email, this.profileImage,this.phone, this.location,this.jobTitle});

  UserModel.fromJason(Map<String,dynamic>json){
    userName=json["UserName"];
    email=json["Email"];
    profileImage=json["profileImage"];
    uid = json["uid"];
    phone = json["phone"];
    location = json["Location"];
    jobTitle = json["JobTitle"];
  }


}