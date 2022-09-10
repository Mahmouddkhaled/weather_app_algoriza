import 'package:http/http.dart' as http;
class WeatherClient {
  Future<String?> getWeatherToday(String city)async{
    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse("https://api.weatherapi.com/v1/forecast.json?key=3abc4ac71f114deb86380405201809&q=$city&days=7&aqi=no&alerts=no"));
    if(response.statusCode == 200){
      return response.body;
    }else {
      return null;
    }
  }
}