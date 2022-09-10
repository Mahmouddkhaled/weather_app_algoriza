import 'package:flutter/material.dart';
import 'package:weather_task/bloc/get_all_bloc.dart';
import 'package:weather_task/colors.dart';
import 'package:weather_task/data/model/location_model.dart';
import 'package:weather_task/database/database_service.dart';
DatabaseService databaseService = DatabaseService.getInstance()!;
AppBar buildAppBar(GetAllBloc bloc, BuildContext context,{LocationModel? model ,String? title}){

  return AppBar(
  backgroundColor: bgColor,
  elevation: 0,
  title: Text(title ?? " "),
  actions:  [
    Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
          onTap: ()async{
           bool isAdded =  await databaseService.insertLocation(model!.name!,model.lng!, model.lat!);
           isAdded ?  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location added successfully")))
           : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location is added before")));
            bloc.getAllSavedLocation();
           },
          child :const Icon(Icons.add, color: Colors.white,)),
    ),


  ],

);
}