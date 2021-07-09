import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/UserModel.dart';

class MediaRepo{
  Future<String> uploadFile(String filePath) async{
    Uri uri = Uri.http(URL_API, "upload/");
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    http.StreamedResponse result = await request.send();
    if(result.statusCode != 200) {
      throw Exception("Error fetching users");
    }else {
      final jsonDecoded = json.decode(await result.stream.bytesToString());
      return jsonDecoded["file_name"];
    }
  }
}