import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/core/services/auth_services.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>  {
  AuthCubit(this.authService) : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  final AuthService authService;

  bool isAcceptTermsRegister = false;
  bool isAcceptTermsLogin = false;
  bool isPassWordShowed = false;

  String currentUid = "";

  bool isOtpVerified = false;

  // OTP Controllers
  TextEditingController otpController = TextEditingController();

  TextEditingController userPhoneNumber = TextEditingController();

  // Login Controllers
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  // SignUp Controllers
  GlobalKey<FormState> signKey = GlobalKey<FormState>();
  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpUserName = TextEditingController();

  // Password Controllers
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordStrength = false;

  Future<void> fireAuthLogin() async {
    emit(LoadingLoginState());

    final result = await authService.signIn(
      loginEmail.text.trim(),
      loginPassword.text.trim(),
    );

    result.fold(
      (failure) {
        emit(ErrorLoginState(
          message: failure.message
        ));
      },
      (user) {
        currentUid = user.uid;
        storeDataLocally(user);
        emit(SuccessLoginState());
      },
    );
  }

  Future<void> signUpWithFire() async {
    emit(LoadingRegisterState());

    final result = await authService.signUp(
      email: signUpEmail.text.trim(),
      password: passwordController.text.trim(),
      name: "${ProfileCubit.firstName.text.trim()} ${ProfileCubit.lastName.text.trim()}",
      phone: userPhoneNumber.text,
      location: ProfileCubit.userLocation.text,
      jobTitle: ProfileCubit.currentStatus,
    );

    result.fold(
      (failure) {
        emit(ErrorRegisterState(message: failure.message));
      },
      (user) {
        currentUid = user.uid;
        storeDataLocally(user);
        print(" ${user.uid}"); 
         emit(SuccessRegisterState());
      },
    );
  }

  Future<void> logout() async {
    emit(LoadingLogoutState());

    final result = await authService.signOut();

    result.fold(
      (failure) {
        emit(ErrorLogoutState(message: failure.message));
      },
      (e) {
        clearControllers();
        LocalData.clearData();
        emit(SuccessLogoutState(message: e));
      },
    );
  }




  Future<void> sendOtp(String phoneNumber) async {
    try {
      emit(LoadingSendOtpState());
      final result = await authService.sendOtpToWhatsApp(phoneNumber);
      result.fold(
        (failure) {
          emit(ErrorOtpSentState());
          Fluttertoast.showToast(
              msg: failure.message, backgroundColor: Colors.red);
        },
        (otp) {
          Fluttertoast.showToast(
              msg: "OTP sent to $phoneNumber",
              backgroundColor: AppColor.orange);
          emit(SuccessOtpSentState());
        },
      );
    } catch (e) {
      log("Error sending OTP: $e");
      emit(ErrorOtpSentState());
      Fluttertoast.showToast(
          msg: "Failed to send OTP", backgroundColor: Colors.red);
    }
  }

  Future<void> verifyOtp({required String otp}) async {
    emit(LoadingVerifyOtpState());

    final result = await authService.verifyOtp(
        inputOtp: otp, phoneNumber: userPhoneNumber.text);

    print(result);

    if (result.isRight()) {
      isOtpVerified = true;
      emit(SuccessOtpVerifiedState());
      Fluttertoast.showToast(
          msg: "OTP Verified Successfully", backgroundColor: AppColor.orange);
    } else {
      emit(ErrorOtpVerifiedState());
      Fluttertoast.showToast(msg: "Invalid OTP", backgroundColor: Colors.red);
    }
  }

  void storeDataLocally(UserModel user) {
    LocalData.setData(key: SharedKey.uid, value: user.uid);
    LocalData.setData(key: SharedKey.email, value: user.email);
    LocalData.setData(key: SharedKey.userName, value: user.userName);
    LocalData.setData(key: SharedKey.isLogin, value: true);
    LocalData.setData(key: SharedKey.userImage, value: user.profileImage);
  }

  void passwordConfirmation() {
    if (passwordController.text == confirmPasswordController.text) {
      passwordStrength = true;
      emit(PasswordMatchState());
    } else {
      passwordStrength = false;
      emit(PasswordNotMatchState());
    }
  }

  void showPassword() {
    isPassWordShowed = !isPassWordShowed;
    emit(PasswordAppearanceState());
  }

  void passwordListener() {
    passwordController.addListener(passwordConfirmation);
    confirmPasswordController.addListener(passwordConfirmation);
  }

  void closeListeners() {
    passwordController.removeListener(passwordConfirmation);
    confirmPasswordController.removeListener(passwordConfirmation);
  }

  void acceptTermsRigster() {
    isAcceptTermsRegister = !isAcceptTermsRegister;
    emit(AcceptTermsRigsterIsOnOrOffState());
  }

  void acceptTermsLogin() {
    isAcceptTermsLogin = !isAcceptTermsLogin;
    emit(AcceptTermsLoginIsOnOrOffState());
  }

  void clearControllers() {
    closeListeners();
    loginEmail.clear();
    loginPassword.clear();
    signUpEmail.clear();
    signUpUserName.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpController.clear();
  }
}
