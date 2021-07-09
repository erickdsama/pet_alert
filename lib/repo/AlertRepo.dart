import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/AlertModel.dart';

class AlertRepo{

  Future<List<AlertModel>> fetchMyAlerts() async{
    Uri uri = Uri.http(URL_API, 'alert');

    final result = await http.get(uri);
    if(result.statusCode != 200) {
      throw Exception("djnskjndjknkjsn");
    }else {
      return parsedJSON(result);
    }
  }

  Future<List<AlertModel>> fetchNearbyAlertPets(String lat, String lon) async{
    Uri uri = Uri.http(URL_API, 'alert/$lon/$lat');
    final result = await http.get(uri);
    if(result.statusCode != 200) {
      throw Exception("djnskjndjknkjsn");
    }else {
      return parsedJSON(result);
    }

  }
  List<AlertModel> parsedJSON(final response) {
    final jsonDecoded = json.decode(response.body);
    List<AlertModel> models = [];
    for(int i=0; i<jsonDecoded.length; i++) {
      models.add(AlertModel.fromJSON(jsonDecoded[i]));
    }
    return models;
  }

}