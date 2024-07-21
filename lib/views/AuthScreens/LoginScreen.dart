import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomRadio.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/AppColor.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return     Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50,),
                  CustomText(
                    text: 'Welcome Back !',
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                    fontSize: 20,
                  ),
                  SizedBox(height: 10,),
                  CustomText(
                    text: 'Plearse log in to join the meeting hub',
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w200,
                    color: AppColor.white,
                    fontSize: 16,
                  ),
                  SizedBox(height: 20,),
                  CustomTextFormField(
                    hintText: 'Enter your email address',
                    controller: null,
                    obscureText: false,
                     validator: (value){
                       if(value!.isEmpty){
                         return 'Please enter your email';
                       }
                       return null;
                     },
                  ),
                  SizedBox(height: 20,),
                  CustomRadioButton(value: 1, groupValue: 1, onChanged: (value) {
                    print(value);
                  }, labelText: 'Remember me'),
                ],
              ),
            ),
            CustomButton(borderColor: AppColor.darkGrey, backgroundColor: AppColor.darkGrey, routeName: RouteConst.home, text: "Next"),
          ],
        ),
      ),



    );
  }
}
