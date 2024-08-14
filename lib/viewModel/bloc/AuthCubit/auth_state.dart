part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}



// privacy 
class AcceptTermsIsOnOrOffState extends AuthState {}


// password
class PasswordAppearanceState extends AuthState{}


// password match
class PasswordMatchState extends AuthState{}
class PasswordNotMatchState extends AuthState{}


// login 
class LoadingLoginState extends AuthState{}
class SuccessLoginState extends AuthState{}
class ErrorLoginState extends AuthState{}


// sign up
class LoadingRegisterState extends AuthState{}
class SuccessRegisterState extends AuthState{}
class ErrorRegisterState extends AuthState{}








