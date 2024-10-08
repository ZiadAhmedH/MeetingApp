import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/viewModel/bloc/CommonFunction.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meta/meta.dart';
import '../../../utils/CollectionConst.dart';
import '../../data/SharedKeys.dart';
import '../../data/SharedPrefrences.dart';
import '../VerfiyCubit/verfiy_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>  implements CommonFun{
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);


  @override
  bool isAcceptTerms = false;
  bool isPassWordShowed = false;

  String currentUid = "";

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmail.text,
        password: loginPassword.text,
      ).then((value) {
        debugPrint(value.user?.email);
        print(value.user?.uid);
        storeDataFirebase(value);
        Fluttertoast.showToast(
            msg: "Login Successfully", backgroundColor: AppColor.green);
        emit(SuccessLoginState());
      }).catchError((error) {
         Fluttertoast.showToast(msg: error);
        emit(ErrorLoginState());
      });
    }


  Future<void> signUpWithFire() async {
    emit(LoadingRegisterState());
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signUpEmail.text, password: passwordController.text).then((value) async {
      await addUserToFireStore(value);
      Fluttertoast.showToast(
          msg: "SignUp Successfully", backgroundColor: AppColor.orange);
      emit(SuccessRegisterState());
    }).catchError((error) {
      emit(ErrorRegisterState());
      Fluttertoast.showToast(msg: error.toString());
      print(error);
    });
  }


  Future<void> addUserToFireStore(UserCredential userCredential) async {
    final user = userCredential.user;
    if (user == null) {
      throw Exception("User is null. Unable to add to Firestore.");
    }
    final uid = user.uid;
    currentUid = uid;
    await FirebaseFirestore.instance.collection(Collections.users).doc(uid).set({
      "UserName": "${ProfileCubit.firstName.text} ${ProfileCubit.lastName.text}",
      "Email": signUpEmail.text,
      "Location": ProfileCubit.userLocation.text,
      "JobTitle": ProfileCubit.currentStatus,
      "phone": VerfiyCubit.userPhoneNumber.text,
      "uid": uid
    });
    log("User added to Firestore" + currentUid);
  }



  void storeDataFirebase(UserCredential value) {
    debugPrint("Using StoreDataFirebase");
    LocalData.setData(key: SharedKey.uid, value: value.user?.uid);
    LocalData.setData(key: SharedKey.email, value: value.user?.email);
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
    print(isAcceptTerms);
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
  }





}





