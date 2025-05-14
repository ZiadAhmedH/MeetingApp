import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/services/auth_services.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/CollectionConst.dart';
import 'package:meeting_app/viewModel/bloc/CommonFunction.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> implements CommonFun {
  AuthCubit(this.authService) : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  final AuthService authService;

  @override
  bool isAcceptTerms = false;
  bool isPassWordShowed = false;

  String currentUid = "";

  // OTP Controllers
  TextEditingController otpController = TextEditingController();
  String? generatedOtp;

  // Phone Number Controllers

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
        emit(ErrorLoginState());
        Fluttertoast.showToast(msg: failure.message, backgroundColor: Colors.red);
      },
      (user) {
        currentUid = user.uid!;
        storeDataLocally(user);
        emit(SuccessLoginState());
        Fluttertoast.showToast(msg: "Login Successful", backgroundColor: AppColor.orange);
      },
    );
  }

  Future<void> signUpWithFire() async {
    emit(LoadingRegisterState());

    final result = await authService.signUp(
      signUpEmail.text.trim(),
      passwordController.text.trim(),
      signUpUserName.text.trim(),
      phone: userPhoneNumber.text,
      location: ProfileCubit.userLocation.text,
      jobTitle: ProfileCubit.currentStatus,
      profileImage: null,
    );

    result.fold(
      (failure) {
        emit(ErrorRegisterState());
        Fluttertoast.showToast(msg: failure.message, backgroundColor: Colors.red);
      },
      (user) async {
        currentUid = user.uid!;
        await addUserToSupabase(user);
        storeDataLocally(user);
        emit(SuccessRegisterState());
        Fluttertoast.showToast(msg: "SignUp Successful", backgroundColor: AppColor.orange);

        // Send OTP after successful registration
        await sendOtp(user.phone!);
      },
    );
  }

  // Method to send OTP to the phone number
  Future<void> sendOtp(String phoneNumber) async {
    try {
      emit(LoadingSendOtpState());
      
      final result = await authService.sendOtp(phoneNumber);
      result.fold(
        (failure) {
          emit(ErrorOtpSentState());
          Fluttertoast.showToast(msg: failure.message, backgroundColor: Colors.red);
        },
        (otp) {
          generatedOtp = otp;
          Fluttertoast.showToast(msg: "OTP sent to $phoneNumber", backgroundColor: AppColor.orange);
          emit(SuccessOtpSentState());
        },
      );
    } catch (e) {
      log("Error sending OTP: $e");
      emit(ErrorOtpSentState());
      Fluttertoast.showToast(msg: "Failed to send OTP", backgroundColor: Colors.red);
    }
  }

  // Verify OTP entered by the user
  Future<void> verifyOtp() async {
    emit(LoadingVerifyOtpState());

    if (otpController.text == generatedOtp) {
      // OTP is correct, proceed with finalizing registration/authentication
      emit(SuccessOtpVerifiedState());
      Fluttertoast.showToast(msg: "OTP Verified Successfully", backgroundColor: AppColor.orange);
    } else {
      emit(ErrorOtpVerifiedState());
      Fluttertoast.showToast(msg: "Invalid OTP", backgroundColor: Colors.red);
    }
  }

  Future<void> addUserToSupabase(UserModel user) async {
    try {
      await Supabase.instance.client.from(Collections.users).insert({
        "UserName": "${ProfileCubit.firstName.text} ${ProfileCubit.lastName.text}",
        "Email": signUpEmail.text,
        "Location": ProfileCubit.userLocation.text,
        "JobTitle": ProfileCubit.currentStatus,
        "phone": userPhoneNumber.text,
        "uid": user.uid,
      });
      log("User added to Supabase: ${user.uid}");
    } catch (e) {
      log("Error adding user to Supabase: $e");
    }
  }

  void storeDataLocally(UserModel user) {
    LocalData.setData(key: SharedKey.uid, value: user.uid);
    LocalData.setData(key: SharedKey.email, value: user.email);
    LocalData.setData(key: SharedKey.isLogin, value: true);
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

  @override
  void acceptTerms() {
    isAcceptTerms = !isAcceptTerms;
    emit(AcceptTermsIsOnOrOffState());
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
