import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.primaryBackgroundColor,
        title: CustomText(text: 'Join Meeting', fontSize: 20.0, fontWeight: FontWeight.bold, color: context.thirdTextColor),
      ),
      body:Expanded(
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomText(text: 'Enter Meeting ID', fontSize: 20.0, fontWeight: FontWeight.bold, color: context.thirdTextColor),
            SizedBox(height: 20),
             CustomTextFormField(hintText: "Meeting Id", icon: Icon(Icons.video_call),),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: CustomText(text: 'Join Meeting', fontSize: 20.0, fontWeight: FontWeight.bold, color: context.primaryBackgroundColor),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(context.thirdTextColor),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              ),
            ),
          ],
        )
      )
    );
  }
}
