class RegexConst{
  static const String email = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String password = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+[\]{};:"|\\,.<>\/?`~-=])[A-Za-z\d!@#$%^&*()_+[\]{};:"|\\,.<>\/?`~-=]{8,}$';
  static const String phoneNumber = r'^01[0125][0-9]{8}$';
  static const String name = r'^[a-zA-Z]{3,}$';
}