import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_alert/models/AlertModel.dart';

class AlertRepo{

  Future<List<AlertModel>> fetchMyAlerts() async{
    var url = 'http://167.99.170.7:5000/alert/';
    final result = await http.get(url);
    if(result.statusCode != 200) {
      print("res ${result.body}" );
      throw Exception("djnskjndjknkjsn");
    }else {
      return parsedJSON(result);
    }
  }

  Future<List<AlertModel>> fetchNearbyAlertPets(String lat, String lon) async{
    var url = 'http://167.99.170.7:5000/alert/$lon/$lat/';
    print("Url ${url}");
    final result = await http.get(url);
    if(result.statusCode != 200) {
      throw Exception("djnskjndjknkjsn");
    }else {
      print("result ${parsedJSON(result)}");
      return parsedJSON(result);
    }

  }
  List<AlertModel> parsedJSON(final response) {
    final jsonDecoded = json.decode(response.body);
    List<AlertModel> models = [];
    for(int i=0; i<jsonDecoded.length; i++) {
      models.add(AlertModel.fromJSON(jsonDecoded[i]));
    }
    print("si?? $models");

    return models;
  }

}