import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_task/data/client/weather_client.dart';
import 'package:weather_task/data/model/location_model.dart';
import 'package:weather_task/data/model/weather_model.dart';

class DatabaseService {
   Database? database;
   String tableName = "Location";
   String nameAttr = "name";
   String latAttr = "lat";
   String lngAttr = "lng";
   String isFavoriteAttr = "isFavorite";
   static DatabaseService? _databaseService ;

   DatabaseService._();
   static DatabaseService? getInstance (){
     _databaseService ??= DatabaseService._();
     return _databaseService;
   }
   WeatherClient _weatherClient = WeatherClient();
   createDatabase ()async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'weather.db');
     await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, $nameAttr TEXT, $lngAttr REAL, $latAttr REAL , $isFavoriteAttr TEXT)');
        }).then((value) {
          database = value;
    });
  }
  Future<bool> insertLocation (String name , double lng , double lat)async{
   List<LocationModel> result = await getAllLocations();
   if(!checkIfExist(result, name)){
     await database!.insert( tableName,
         {nameAttr : name,
           lngAttr : lng,
           latAttr : lat,
           isFavoriteAttr:"false"
         }
     ).then((value) {
       debugPrint("added $value");
     });
     return true;
   }else {
     return false;
   }

  }
  favorite(String name )async{
     await database!.rawUpdate(
        'UPDATE $tableName SET $isFavoriteAttr = ? WHERE name = ?',
        ['true', name]);
  }
  unFavorite(String name )async{
    await database!.rawUpdate(
        'UPDATE $tableName SET $isFavoriteAttr = ? WHERE name = ?',
        ['false', name]);
  }
  deleteLocation(String name )async{
    await database
        !.rawDelete('DELETE FROM $tableName WHERE name = ?', [name]);
   }
   Future<List<LocationModel>> getAllLocations () async{
    List<Map> list = await database!.rawQuery('SELECT * FROM $tableName');
    List<LocationModel> result = [];
    debugPrint(list.toString());
    list.forEach((element)async {
    LocationModel model=  LocationModel.empty();
      model.fromMap(element);
     result.add(model);
    });
    return result;
  }
  Future<List<LocationModel>> getAllLocationsWithTemp () async{
    List<Map> list = await database!.rawQuery('SELECT * FROM $tableName');
    List<LocationModel> result = [];
    debugPrint(list.toString());
    list.forEach((element)async {
      var myWeather =  await _weatherClient.getWeatherToday(element["name"]);
      WeatherModel weatherModel = WeatherModel.fromJson(jsonDecode(myWeather!));

      LocationModel model=  LocationModel.empty();
      model.temp = weatherModel.current!.tempC;

      model.fromMap(element);
     result.add(model);
    });
    return result;
  }

  bool checkIfExist(List<LocationModel> result, String name) {
    bool isExist = false ;
     result.forEach((element) {
       if(element.name == name){
         isExist= true;
       }
     });
     return isExist;
  }
}