import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_task/data/client/weather_client.dart';
import 'package:weather_task/data/model/location_model.dart';
import 'package:weather_task/data/model/weather_model.dart';
import 'package:weather_task/database/database_service.dart';

class GetAllBloc extends Cubit<GetAllState>{
  GetAllBloc(super.initialState);
  DatabaseService databaseService = DatabaseService.getInstance()!;

  getAllSavedLocation ()async{
   List<LocationModel> result =  await databaseService.getAllLocationsWithTemp();
    emit(GetAllState(result));
  }

}
class GetAllState {
  String? error ;
  List<LocationModel>? result ;

  GetAllState(this.result);
  GetAllState.empty();
  GetAllState.withError(this.error);
}