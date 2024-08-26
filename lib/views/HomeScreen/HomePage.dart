import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

import '../../../viewModel/bloc/ThemeCubit/theme_cubit.dart';
import '../../viewModel/bloc/AuthCubit/auth_cubit.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeCubit = ThemesCubit.get(context);
    var profileCubit = ProfileCubit.get(context);
    var authCubit = AuthCubit.get(context);
    return  Scaffold(
      backgroundColor:context.primaryBackgroundColor,
       appBar:AppBar(
         backgroundColor:context.primaryBackgroundColor ,
          title:CustomText(text: "Meeting" ,fontFamily: "Gilroy",fontWeight: FontWeight.bold,fontSize: 20,color: context.thirdTextColor,),
         leading: CircleAvatar(
           radius: 20,
           backgroundColor: context.primaryIconColor,
         ),
       ) ,

      body: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: (){
                  profileCubit.uploadImage(image: profileCubit.image!);
                }, child: Text("change"),
              ),
            ],
          ),
      ),
    );
  }
}
