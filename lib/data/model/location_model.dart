class LocationModel {
  String? name ;
  double? lat ,lng ;
  String? isFavorite ;
  double? temp ;

  LocationModel(this.name, this.lat, this.lng, this.isFavorite);
  LocationModel.empty();
  fromMap(Map map){
    name = map["name"];
    lat = map["lat"];
    lng = map["lng"];
    isFavorite = map["isFavorite"];
  }
}