
import 'package:flutter/material.dart';
import 'package:meeting_app/Routeres/go_Router.dart';
import 'package:meeting_app/views/splashScreen.dart';

void main(){
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp.router(
      title: 'Meeting App',
     routerConfig: AppRouter().router,
    );
  }
}