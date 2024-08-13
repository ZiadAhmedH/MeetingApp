import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

part 'verfiy_state.dart';

class VerfiyCubit extends Cubit<VerfiyState> {
  VerfiyCubit() : super(VerfiyInitial());
  static VerfiyCubit get(context) => BlocProvider.of(context);



  TextEditingController verificationCode = TextEditingController();
  TextEditingController userPhoneNumber = TextEditingController();
  final auth = FirebaseAuth.instance;
  String? verificationId; // Add this as a class member
  bool isVerify = false;



  Future<void> submitPhoneNumber({required String phone}) async {
    String phoneNumber = '+20 ${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}'; // +20 **** *** *** format mobile number

    emit(LoadingVerfiyState());

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(
          msg: e.message.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        emit(VerfiyErrorState(e.message.toString()));
      },

      codeSent: (String verificationId, int? resendToken) {
        Fluttertoast.showToast(
          msg: 'Code sent to $phoneNumber',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Save the verificationId for later use
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
         if(verificationId.isNotEmpty){
           this.verificationId = verificationId;
         }else{
           Fluttertoast.showToast(
             msg: 'Time out',
             backgroundColor: Colors.red,
             textColor: Colors.white,
           );
         }
      },
      timeout: const Duration(seconds: 60),
    );
  }

  void onSmsCodeSubmitted() {
    if (verificationId != null && verificationCode.text.isNotEmpty) {
      verifyOTP(smsCode: verificationCode.text, verificationId: verificationId!);
      print(verificationCode.text);
      Fluttertoast.showToast(msg: 'Success verify code', backgroundColor: Colors.green);
      emit(VerfiySuccessState());
    } else {
      Fluttertoast.showToast(msg: 'Please enter the SMS code');
    }
  }


  void verifyOTP({required String smsCode, required String verificationId}) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await auth.signInWithCredential(phoneAuthCredential);
      emit(VerfiySuccessState());
      print(phoneAuthCredential.smsCode.toString());
      print(phoneAuthCredential.verificationId);
      print(phoneAuthCredential);
      isVerify = true;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: '${e.message}');
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }





}
