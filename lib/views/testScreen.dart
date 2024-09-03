import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';

import '../model/components/CustomText.dart';
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

TextEditingController controller = TextEditingController();
List<CardInfo> cards = [];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: 'RMR رواد مصر',
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.bold,
          color: context.thirdTextColor,
          fontSize: 20,
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {

            });
          }, icon: const Icon(Icons.info)),
        ],
      ),
      body: Column(
        children: [
        Row(
          children: [

            IconButton(onPressed: () {
              cards.add(CardInfo(text: controller.text));
              controller.clear();
            },
               icon: Icon(Icons.add ,color: Colors.redAccent,)
             ),
          ],
        ),


        ],
      ),

    );

  }
}



class CardInfo extends StatelessWidget {
   Color color;
  final String text;
   CardInfo({super.key, required this.text,  this.color = Colors.white});
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
      },
      child:   Card(
        child: SizedBox(
          height: 100,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: const Icon(Icons.group),
              ),
              title: Text('Study Group $text'),
            ),
          ),
        ),
      ),
    );
  }
}


