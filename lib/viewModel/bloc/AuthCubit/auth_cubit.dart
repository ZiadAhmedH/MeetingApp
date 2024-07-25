import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool isAcceptTerms = false;

  
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  Future<void> acceptTerms() async {
    isAcceptTerms = !isAcceptTerms;
    print(isAcceptTerms);
    emit(AcceptTermsIsOnOrOffState());
    
  }

  //  Future<void> fireAuthLogin() async {
  //   emit(LoadingLoginState());
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: loginEmail.text,
  //     password: loginPassword.text,
  //   ).then((value) {
  //     print(value.user?.email);

  //     //storeDataFirebase(value);
  //     // Fluttertoast.showToast(
  //     //     msg: "Login Successfully", backgroundColor: AppColor.orange);
  //     emit(SuccessfulLoginState());
  //   }).catchError((error) {
  //     Fluttertoast.showToast(msg: error);
  //     emit(ErrorLoginState());
  //   });
  // }




}
