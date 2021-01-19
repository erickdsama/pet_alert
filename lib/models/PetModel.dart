
import 'dart:convert';

import 'package:pet_alert/models/UserModel.dart';

class PetModel{
  String name;
  String photo;
  String id;
  String breed;
  String color;
  String size;
  String disease;
  String medicates;
  double weight;
  UserModel owner;
  double age;
  int sex;

  PetModel({
    this.name,
    this.photo,
    this.id,
    this.breed,
    this.color,
    this.weight,
    this.size,
    this.disease,
    this.medicates,
    this.owner,
    this.age,
    this.sex});


  factory PetModel.fromJSON(Map<String, dynamic> json) {
    return PetModel(
        owner: UserModel.fromJSON(json["owner"]),
        name: json['name'],
        photo: json['photo'],
        breed: json['breed'],
        color: json['color'],
        size: json['size'],
        age: json['age'],
        sex: json['sex'],
        weight: json['weight'],
        medicates: json['medicates'],
        disease: json['disease'],
        id: json['id'].toString());
  }

  String toJSON() {
    return jsonEncode(<String, dynamic>{
      'name': this.name,
      'photo': "https://c.files.bbci.co.uk/EB24/production/_112669106_66030514-b1c2-4533-9230-272b8368e25f.jpg",
      'breed': this.breed,
      'color': this.color,
      'size': this.size,
      // 'weight': this.weight,
      // 'age': this.age, todo fix api problem
      'sex': this.sex,
      'medicates': this.medicates,
      'diseases': this.disease,
    });
  }

}