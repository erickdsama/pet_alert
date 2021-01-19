
import 'dart:convert';

class UserModel{
  String name;
  String photo;
  String email;
  String id;
  double age;
  int sex;
  String gUser;

  UserModel({
    this.name,
    this.photo,
    this.id,
    this.email,
    this.age,
    this.gUser,
    this.sex});


  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        gUser: json['g_user'],
        email: json['email'],
        photo: json['photo'],
        age: json['age'],
        sex: json['sex'],
        id: json['id'].toString());
  }

  String toJSON() {
    return jsonEncode(<String, dynamic>{
      'name': this.name,
      'photo': this.photo,
      'email': this.email,
      'g_user': this.gUser,
      // 'age': this.age, todo fix api problem
//      'sex': this.sex,
    });
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': this.name,
      'photo': this.photo,
      'email': this.email,
      'g_user': this.gUser,
      'id': this.id,
      // 'age': this.age, todo fix api problem
//      'sex': this.sex,
    };
  }

}