import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/UserModel.dart';
import '../utils.dart';

class UserRepo{
  Future<List<UserModel>> fetchUsers(List<String> users) async{
    String url_args = users.join("&id=");
    Uri uri = Uri.http(URL_API, "owner", {
      "id": users
    });
    print("USERS URIIIII $uri");
    final result = await http.get(uri);
    if(result.statusCode != 200) {
      throw Exception("Error fetching users");
    }else {
      return parsedJSON(result);
    }
  }


  Future<UserModel> postUser(data) async{
    assert(data != null);
    Uri uri = Uri.http(URL_API, 'owner');
    Map<String, String> headers = {
      "Content-Type":"application/json"
    };
    final result = await http.post(uri, body: data.toJSON(), headers: headers);
    if(result.statusCode != 200) {
      throw Exception("Error posting user");
    }else {
      return UserModel.fromJSON(jsonDecode(result.body));
    }
  }

  Future<UserModel> getMe() async{
    Uri uri = Uri.http(URL_API, 'me');
    final result = await http.get(uri);
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