import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_task/data/client/weather_client.dart';
import 'package:weather_task/data/model/weather_model.dart';

class HomeBloc extends Cubit<HomeState>{
  HomeBloc(super.initialState);
  WeatherClient weatherClient = WeatherClient();
  getTodayTemp(String city)async{
    String? result = await weatherClient.getWeatherToday(city);
    if(result == null){
      emit(HomeState.withError("There is a problem"));
    }
    else {
       WeatherModel model = WeatherModel.fromJson(jsonDecode(result));
       emit(HomeState(model));
    }
  }


}
class HomeState {
  String? error ;
  WeatherModel? model ;

  HomeState(this.model);
  HomeState.empty();
  HomeState.withError(this.error);
}