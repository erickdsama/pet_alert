import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/PetModel.dart';

class PetRepo{

  Future<List<PetModel>> fetchMyPets() async{
    Uri uri = Uri.http(URL_API, 'pet');
    final result = await http.get(uri);
    if(result.statusCode != 200) {
      throw Exception("PETTTTSSS ERROR");
    }else {
      if(result != null) {
        return parsedJSON(result);
      } else {
        return [];
      }
    }
  }

  Future<PetModel> savePet(final data) async{
    assert(data != null);
    Uri uri = Uri.http(URL_API, 'pet/');
    Map<String, String> headers = {
      "Content-Type":"application/json"
    };
    final result = await http.post(uri, body: data.toJSON(), headers: headers);
    if(result.statusCode != 200) {
      throw Exception(result.body);
    }else {
      return PetModel.fromJSON(json.decode(result.body));
    }
  }

  List<PetModel> parsedJSON(final response) {
    final jsonDecoded = json.decode(response.body);
    List<PetModel> models = [];
    for(int i=0; i<jsonDecoded.length; i++) {
      models.add(PetModel.fromJSON(jsonDecoded[i]));
    }
    return models;
  }


}