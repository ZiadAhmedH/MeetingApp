part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

// Initial State
class AuthInitial extends AuthState {}

// Loading States
class AuthLoadingState extends AuthState {}

// Privacy
class AcceptTermsIsOnOrOffState extends AuthState {}

// Password
class PasswordAppearanceState extends AuthState {}

// Password Match
class PasswordMatchState extends AuthState {}
class PasswordNotMatchState extends AuthState {}

// Login States
class LoadingLoginState extends AuthState {}
class SuccessLoginState extends AuthState {}
class ErrorLoginState extends AuthState {}

// Sign Up States
class LoadingRegisterState extends AuthState {}
class SuccessRegisterState extends AuthState {}
class ErrorRegisterState extends AuthState {}

// OTP States
class LoadingSendOtpState extends AuthState {}
class SuccessOtpSentState extends AuthState {}
class ErrorOtpSentState extends AuthState {}

// OTP Verification States
class LoadingVerifyOtpState extends AuthState {}
class SuccessOtpVerifiedState extends AuthState {}
class ErrorOtpVerifiedState extends AuthState {}
