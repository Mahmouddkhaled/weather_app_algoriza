import 'package:flutter/material.dart';

Color bgColor = const Color(0xff7EB0F1);
Color overlayColor =const Color(0xff8DB7E9);
Color drawerColor =const Color(0xff2E3842);
Color buttonColor =const Color(0xff4E5761);
getCurrentTime (){
  DateTime today = DateTime.now();
  if(today.hour > 18 || today.hour < 5){
    overlayColor =const  Color(0xff171618);
    bgColor =  Colors.black;
  }else {
    bgColor = const Color(0xff7EB0F1);
    overlayColor =const Color(0xff8DB7E9);
  }
}