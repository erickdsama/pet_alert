import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/UserModel.dart';

class UserRepo{

  Future<List<UserModel>> fetchUsers(List<String> users) async{
    var url = 'http://167.99.170.7:5000/user/';
    final result = await http.get(url);
    if(result.statusCode != 200) {
      print("res ${result.body}" );
      throw Exception("djnskjndjknkjsn");
    }else {
      return parsedJSON(result);
    }
  }

  Future<UserModel> getMe() async{
    var url = 'http://167.99.170.7:5000/me';
    final result = await http.get(url);
    if(result.statusCode != 200) {
      throw Exception("djnskjndjknkjsn");
    }else {
      return UserModel.fromJSON(jsonDecode(result.body));
    }

  }
  List<UserModel> parsedJSON(final response) {
    final jsonDecoded = json.decode(response.body);
    List<UserModel> models = [];
    for(int i=0; i<jsonDecoded.length; i++) {
      models.add(UserModel.fromJSON(jsonDecoded[i]));
    }
    return models;
  }

}