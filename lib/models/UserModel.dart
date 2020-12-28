
import 'dart:convert';

class UserModel{
  String name;
  String photo;
  String id;
  double age;
  int sex;

  UserModel({
    this.name,
    this.photo,
    this.id,
    this.age,
    this.sex});


  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        photo: json['photo'],
        age: json['age'],
        sex: json['sex'],
        id: json['id'].toString());
  }

  String toJSON() {
    return jsonEncode(<String, dynamic>{
      'name': this.name,
      'photo': "https://c.files.bbci.co.uk/EB24/production/_112669106_66030514-b1c2-4533-9230-272b8368e25f.jpg",
      // 'age': this.age, todo fix api problem
      'sex': this.sex,
    });
  }

}