import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:weather_task/bloc/get_all_bloc.dart';
import 'package:weather_task/bloc/home_bloc.dart';
import 'package:weather_task/colors.dart';
import 'package:weather_task/custom_widgets.dart';
import 'package:weather_task/data/model/location_model.dart';
import 'package:weather_task/database/database_service.dart';
import 'package:weather_task/images.dart';
import 'package:weather_task/locationService/location_service.dart';
import 'package:weather_task/styles.dart';
import 'package:weather_task/widgets/build_item.dart';
import 'package:weather_task/widgets/separator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
   getCurrentLocation();
   getAllBloc.getAllSavedLocation();
    super.initState();
  }
  List<LocationModel>? savedLocation;
  BehaviorSubject<List<LocationModel>> rxSavedLocations = BehaviorSubject();
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<LocationModel>(
      stream: rxLocation.stream,
      builder: (context, snapshot) {
        return Scaffold(
            backgroundColor: bgColor,
            appBar: snapshot.data != null ? buildAppBar(getAllBloc , context ,model: snapshot.data) :buildAppBar(getAllBloc, context) ,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15),
              child: BlocBuilder<HomeBloc,HomeState>(
                bloc: bloc,
                builder: (context, HomeState state) {
                  if (state.model == null && state.error == null){
                    return const Center(
                      child: CircularProgressIndicator( backgroundColor:Colors.white),
                    );
                  }else if(state.error == null)
                 {
                   return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text("${state.model!.current!.tempC.toString()}°", style: buildTextStyle(size: 50, color: Colors.white),),
                            Image.asset(getApproperiateImage(state.model!.current!.tempC!),
                              width: MediaQuery.of(context).size.width *.25 ,
                            height: MediaQuery.of(context).size.width *.25,
                            )
                          ],
                        ),
                        Row(
                          children:  [
                            Text(state.model!.location!.name!, style: buildTextStyle(size: 20, color: Colors.white),),
                           const Icon(Icons.location_pin , color: Colors.white,)
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          children:  [
                            Text("${state.model!.forecast!.forecastday!.first.day!.maxtempC}° / ${state.model!.forecast!.forecastday!.first.day!.avgtempC}° Feels Like ${state.model!.forecast!.forecastday!.first.day!.avgtempC}°",style: buildTextStyle(size: 13, color: Colors.white)),
                          ],
                        ),
                          Text("${
                              state.model!.current!.lastUpdated
                          }",style: buildTextStyle(size: 13, color: Colors.white)),
                        const SizedBox(height: 40,),
                        Container(
                          height: MediaQuery.of(context).size.height *.30,
                          decoration: BoxDecoration(
                            color: overlayColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *.130,
                                child: ListView.builder(
                                  itemCount: state.model!.forecast!.forecastday!.first.hour!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (c , index){
                                    return SizedBox(
                                      height: MediaQuery.of(context).size.height * .15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children:  [

                                             Text("${
                                                 DateTime.parse(state.model!.forecast!.forecastday!.first.hour![index].time!).hour
                                             }:${
                                                 DateTime.parse(state.model!.forecast!.forecastday!.first.hour![index].time!).minute
                                             }" , style: buildTextStyle(color: Colors.white, size: 12 , fontWeight: FontWeight.w500),),
                                            Image.asset(getApproperiateImage(state.model!.forecast!.forecastday!.first.hour![index].tempC!) , width: 30 ,height: 30,),
                                             Text("${state.model!.forecast!.forecastday!.first.hour![index].tempC}°",style: buildTextStyle(color: Colors.white, size: 12 , fontWeight: FontWeight.w500))
                                          ],
                                        ),
                                      ),
                                    );
                                  } ,),
                              ),
                              Container(
                                height: 50,
                                  padding: const EdgeInsets.all(16.0),
                                  child:  SfSparkLineChart(
                                  //Enable the trackball
                                  color: Colors.white,
                                  axisLineWidth: 0,
                                  trackball: const SparkChartTrackball(
                                      activationMode: SparkChartActivationMode.tap),
                                  //Enable marker
                                  marker: const SparkChartMarker(
                                      displayMode: SparkChartMarkerDisplayMode.all),
                                  //Enable data label
                                  data: getList( state.model!.forecast!.forecastday!.first.hour!.map((e) => e.tempC).toList()),
                                )
                              ),
                              SizedBox(
                                height: 20,
                                child: ListView.builder(
                                    itemCount: state.model!.forecast!.forecastday!.first.hour!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (c, index){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    child: Row(
                                      children:  [
                                        const Icon(Icons.water_drop , color: Colors.white,size: 16,),
                                        Text("${state.model!.forecast!.forecastday!.first.hour![index].chanceOfRain}%", style: buildTextStyle(color: Colors.white),)
                                      ],
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height *.1,
                          width: MediaQuery.of(context).size.width ,
                          decoration: BoxDecoration(
                            color: overlayColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Today's Temperture" , style: buildTextStyle(color: Colors.white , size: 16 , fontWeight: FontWeight.bold),),
                              const SizedBox(height: 4,),
                              Text("Today's Temperture" , style: buildTextStyle(color: Colors.white , size: 12 , fontWeight: FontWeight.normal),)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height *.06  * 3,
                          width: MediaQuery.of(context).size.width ,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: overlayColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (c, index ){
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                     Text(
                                         DateFormat('EEEE').format(
                                    DateTime.parse(state.model!.forecast!.forecastday![index].date!)),style: buildTextStyle(color: Colors.white),), /// e.g Thursday}" ,style: buildTextStyle(size: 16 ,color: Colors.white) ),
                                    Row(
                                      children:  [
                                       const Icon(Icons.water_drop , color: Colors.white,size: 16,),
                                        Text("${state.model!.forecast!.forecastday![index].day!.dailyChanceOfRain}%", style: buildTextStyle(color: Colors.white),)
                                      ],
                                    ),
                                    Image.asset(getApproperiateImage(state.model!.forecast!.forecastday![index].day!.maxtempC!) , width: 25,height: 25,),
                                    Image.asset(getApproperiateImage(state.model!.forecast!.forecastday![index].day!.avgtempC!) , width: 25,height: 25,),
                                    Text("${state.model!.forecast!.forecastday![index].day!.maxtempC}°  ${state.model!.forecast!.forecastday![index].day!.avgtempC}°" ,style: buildTextStyle(size: 15, color: Colors.white) ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height *.17,
                          width: MediaQuery.of(context).size.width ,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: overlayColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                  buildItem("Sunrise", state.model!.forecast!.forecastday!.first.astro!.sunrise!, sunrise),
                                  buildItem("Sunset", state.model!.forecast!.forecastday!.first.astro!.sunset!, sunset),
                              ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height *.17,
                          width: MediaQuery.of(context).size.width ,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: overlayColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildWeatherConditionItem( "UV Index",state.model!.current!.uv!.toString(),UvIndex),
                              buildWeatherConditionItem("Wind",state.model!.current!.windKph!.toString() + "Km/h",wind),
                              buildWeatherConditionItem("Humidity",state.model!.current!.humidity!.toString() + "%",humidilty),
                              ],
                          ),
                        ),

                      ],
                    ),
                  );
                }else {
                    return  Center(
                      child: Text(state.error!),
                    );
                  }
                }
              ),
            ),
          drawer:
             BlocBuilder<GetAllBloc ,GetAllState  >(
            bloc: getAllBloc,
            builder: (context, snapshot) {
               savedLocation = snapshot.result!;
               List<LocationModel> favoriteLocations = savedLocation!.where((e) => e.isFavorite == "true").toList();
               List<LocationModel> otherLocations = savedLocation!.where((e) => e.isFavorite == "false").toList();
              rxSavedLocations.sink.add(savedLocation!);
        return     Drawer(
          child: Container(
            color: bgColor,
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Container(
                  height: MediaQuery.of(context).size.height - 40,
                  decoration:  BoxDecoration(
                      color: drawerColor,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12) , bottomRight: Radius.circular(12))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(Icons.settings_outlined, color: Colors.white,)
                          ],
                        ),
                        const SizedBox(height: 40,),
                        Row(
                          children:  [
                            const Icon(Icons.star , color: Colors.white,),
                            const SizedBox(width: 16,),
                            Text("Favorites Location" , style: buildTextStyle(color: Colors.white,size: 14),),
                            const Spacer(),
                            const Icon(Icons.info_outline , color: Colors.white ,)
                          ],
                        ),
                        ListView.builder(
                            itemCount:favoriteLocations .length,
                            shrinkWrap: true,
                            itemBuilder: (ctx , index){
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0,top: 5, bottom: 5),
                                child: Row(
                                  children:  [
                                    const Icon(Icons.location_pin , color: Colors.white, size: 10,) ,
                                    const SizedBox(width: 4,),
                                    Text(favoriteLocations[index].name! ,style: buildTextStyle(color: Colors.white, fontWeight: FontWeight.bold , size: 16) ,),
                                    const Spacer(),
                                    Image.asset(getApproperiateImage(favoriteLocations[index].temp!), width: 20,height: 20,),
                                    const SizedBox(width: 4,),
                                    Text("${favoriteLocations[index].temp}° " , style: buildTextStyle(color: Colors.white ,size: 16 ),)
                                  ],
                                ),
                              );
                            }),
                        const SizedBox(height: 10,),
                        const MySeparator() ,
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.location_pin , color: Colors.white),
                            const SizedBox(width: 16,),
                            Text("Other Locations" , style: buildTextStyle(color: Colors.white,size: 14),),
                          ],
                        ),
                        ListView.builder(
                            itemCount: otherLocations.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx , index){
                              return Padding(
                                padding: const EdgeInsets.only(left: 40.0,top: 5, bottom: 5),
                                child: Row(
                                  children:  [
                                    const SizedBox(width: 4,),
                                    Text(otherLocations[index].name! ,style: buildTextStyle(color: Colors.white, fontWeight: FontWeight.normal , size: 15) ,),
                                    const Spacer(),
                                    Image.asset(getApproperiateImage(otherLocations[index].temp!), width: 20,height: 20,),
                                    const SizedBox(width: 4,),
                                    Text("${otherLocations[index].temp}°" , style: buildTextStyle(color: Colors.white ,size: 16 ),)
                                  ],
                                ),
                              );
                            }),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            showDialog(context: context, builder: (c){
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                  decoration: BoxDecoration(color: drawerColor,borderRadius: BorderRadius.circular(16)),
                                  height: MediaQuery.of(context).size.height * .6,
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_pin , color: Colors.white),
                                            const SizedBox(width: 16,),
                                            Text("Other Locations" , style: buildTextStyle(color: Colors.white,size: 20),),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        StreamBuilder<List<LocationModel>>(
                                            stream: rxSavedLocations.stream,
                                            builder: (context, snapshot) {
                                              return ListView.builder(
                                                  itemCount: savedLocation!.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (ctx , index){
                                                    return Padding(
                                                      padding: const EdgeInsets.only(left: 20.0,top: 5, bottom: 5),
                                                      child: Row(
                                                          children:  [
                                                            GestureDetector(
                                                                onTap :()async{
                                                                  await DatabaseService.getInstance()!.deleteLocation(savedLocation![index].name!);
                                                                  savedLocation!.removeAt(index);
                                                                  rxSavedLocations.sink.add(savedLocation!);
                                                                },
                                                                child: const Icon(Icons.delete, color: Colors.white,)),
                                                            const SizedBox(width: 4,),
                                                            Text(savedLocation![index].name! ,style: buildTextStyle(color: Colors.white, fontWeight: FontWeight.normal , size: 15) ,),
                                                            const Spacer(),
                                                            Image.asset(getApproperiateImage(savedLocation![index].temp!), width: 20,height: 20,),
                                                            const SizedBox(width: 4,),
                                                            Text("${savedLocation![index].temp} °" , style: buildTextStyle(color: Colors.white ,size: 16 ),),
                                                            savedLocation![index].isFavorite == "true" ?
                                                            GestureDetector(
                                                                onTap: (){
                                                                  DatabaseService.getInstance()!.unFavorite(savedLocation![index].name!);
                                                                  favoriteLocations.remove(savedLocation![index]);
                                                                  savedLocation![index].isFavorite = "false";
                                                                  rxSavedLocations.sink.add(savedLocation!);

                                                                },
                                                                child: const Icon(Icons.favorite, color: Colors.white,)): GestureDetector(
                                                                onTap: (){
                                                                  DatabaseService.getInstance()!.favorite(savedLocation![index].name!);
                                                                  favoriteLocations.add(savedLocation![index]);
                                                                  savedLocation![index].isFavorite = "true";
                                                                  rxSavedLocations.sink.add(savedLocation!);
                                                                },child: const Icon(Icons.favorite_border_outlined, color: Colors.white,)),
                                                          ]
                                                      ),
                                                    );
                                                  });
                                            }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                          child: Container(
                            margin:const EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                            padding:const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: buttonColor
                            ),
                            child:  Text("Manage locations " , style: buildTextStyle(color: Colors.white, size: 15),),
                          ),
                        ),
                        const MySeparator(),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.info_outline , color: Colors.white),
                            const SizedBox(width: 16,),
                            Text("Report wrong location" , style: buildTextStyle(color: Colors.white,size: 16),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.headphones , color: Colors.white),
                            const SizedBox(width: 16,),
                            Text("Contact us" , style: buildTextStyle(color: Colors.white,size: 16),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        );
        }
        )

        );
      }
    );
  }
  BehaviorSubject<LocationModel> rxLocation = BehaviorSubject();
  HomeBloc bloc = HomeBloc(HomeState.empty());
  GetAllBloc getAllBloc= GetAllBloc(GetAllState.empty());
  void getCurrentLocation() async{
    LocationService service = LocationService();
   Position myPosition =  await service.getMyLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(myPosition.latitude, myPosition.longitude);
    rxLocation.sink.add(LocationModel(placemarks.first.administrativeArea!, myPosition.latitude, myPosition.longitude, "false"));
    /// call bloc with city
    bloc.getTodayTemp( placemarks.first.administrativeArea!);
  }

  List<num> getList(List<double?> list) {
    List<num> result = [];
    list.forEach((element) {
      result.add(element!);
    });
    return result;
  }

  String getApproperiateImage(double temp) {
    if(temp > 30 ){
      return sunImage;
    }else if (temp > 25){
      return halfSunImage;
    }else if (temp > 15){
      return cloudImage;
    }else {
      return rainImage;
    }
  }
}
