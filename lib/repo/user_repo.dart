import 'dart:convert';

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:http/http.dart' as http;
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/UserModel.dart';

import '../utils.dart';

class UserRepo{

  Future<List<UserModel>> fetchUsers(List<String> users) async{
    String url_args = users.join("&id=");
    print("users $users");
    print("ar $url_args");
    var url = 'http://167.99.170.7:5000/owner?id='+url_args;
    final result = await http.get(url);
    if(result.statusCode != 200) {
      print("res ${result.body}" );
      throw Exception("Error fetching users");
    }else {
      return parsedJSON(result);
    }
  }


  Future<UserModel> postUser(data) async{
    assert(data != null);

    var url = 'http://167.99.170.7:5000/owner';
    Map<String, String> headers = {
      "Content-Type":"application/json"
    };
    final result = await http.post(url, body: data.toJSON(), headers: headers);
    if(result.statusCode != 200) {
      throw Exception("Error posting user");
    }else {
      print("user -> ${result.body}");
      return UserModel.fromJSON(jsonDecode(result.body));
    }
  }

  Future<UserModel> getMe() async{
    var url = 'http://167.99.170.7:5000/me';
    final result = await http.get(url);
    if(result.statusCode != 200) {
      throw Exception("Error get my user");
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