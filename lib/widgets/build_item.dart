import 'package:flutter/material.dart';
import 'package:weather_task/images.dart';
import 'package:weather_task/styles.dart';

Widget buildItem(String title , String  time , String image){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title, style: buildTextStyle(color: Colors.white , size: 13,fontWeight: FontWeight.normal),),
      const SizedBox(height: 8,),
      Text(time, style: buildTextStyle(color: Colors.white , size: 15,fontWeight: FontWeight.bold),),
      const SizedBox(height: 8,),
      Image.asset(image, width: 60, height: 60,)
    ],
  );
}
Widget buildWeatherConditionItem(String title , String  time , String image){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(image, width: 60, height: 60,),
      const SizedBox(height: 8,),
      Text(title, style: buildTextStyle(color: Colors.white , size: 15,fontWeight: FontWeight.bold),),
      const SizedBox(height: 8,),
      Text(time, style: buildTextStyle(color: Colors.grey.shade300 , size: 13,fontWeight: FontWeight.normal),),
     ],
  );
}

