import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_alert/models/PetModel.dart';

class PetRepo{

  Future<List<PetModel>> fetchMyPets() async{
    var url = 'http://167.99.170.7:5000/pet/';

    final result = await http.get(url);
    if(result.statusCode != 200) {
      throw Exception("PETTTTSSS ERROR");
    }else {
      return parsedJSON(result);
    }
  }

  Future<PetModel> savePet(final data) async{
    assert(data != null);

    var url = 'http://167.99.170.7:5000/pet/';
    print("sdad ${data.toJSON()}");
    Map<String, String> headers = {
      "Content-Type":"application/json"
    };
    final result = await http.post(url, body: data.toJSON(), headers: headers);
    if(result.statusCode != 200) {
      throw Exception("PETTTTSSS ERROR");
    }else {
      print("dsada ${result.body}");
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