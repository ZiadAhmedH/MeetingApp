part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}



// privacy 
class AcceptTermsIsOnOrOffState extends AuthState {}


// password
class PasswordAppearanceState extends AuthState{}


// login 
class LoadingLoginState extends AuthState{}
class SuccessLoginState extends AuthState{}
class ErrorLoginState extends AuthState{}





