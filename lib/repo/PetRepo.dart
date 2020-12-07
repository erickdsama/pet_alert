import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_alert/models/PetModel.dart';

class PetRepo{

  Future<List<PetModel>> fetchMyPets() async{
    var url = 'http://debian:5000/pet/';

    final result = await http.get(url);
    if(result.statusCode != 200) {
      throw Exception("PETTTTSSS ERROR");
    }else {
      return parsedJSON(result);
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