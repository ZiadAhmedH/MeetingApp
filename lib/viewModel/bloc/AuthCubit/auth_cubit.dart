import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meta/meta.dart';

import '../../data/SharedKeys.dart';
import '../../data/SharedPrefrences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool isAcceptTerms = false;
  bool isPassWordShowed = false;



 // Login Controllers
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();


  void acceptTerms() {
    isAcceptTerms = !isAcceptTerms;
    print(isAcceptTerms);
    emit(AcceptTermsIsOnOrOffState());
  }

  void showPassword() {
    isPassWordShowed = !isPassWordShowed;
    emit(PasswordAppearanceState());
  }

   Future<void> fireAuthLogin() async {
    emit(LoadingLoginState());
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: loginEmail.text,
      password: loginPassword.text,
    ).then((value) {
      debugPrint(value.user?.email);
      storeDataFirebase(value);
       Fluttertoast.showToast(
           msg: "Login Successfully", backgroundColor: AppColor.green);
      emit(SuccessLoginState());
    }).catchError((error) {
      // Fluttertoast.showToast(msg: error);
      emit(ErrorLoginState());
    });
  }
}




  void storeDataFirebase(UserCredential value) {
    debugPrint("Using StoreDataFirebase");
    LocalData.setData(key: SharedKey.uid, value: value.user?.uid);
    LocalData.setData(key: SharedKey.email, value: value.user?.email);
    LocalData.setData(key: SharedKey.userName, value: value.user?.displayName);
  }
