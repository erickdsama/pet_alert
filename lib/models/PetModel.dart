
import 'dart:convert';

import 'package:pet_alert/models/UserModel.dart';

class PetModel{
  String name;
  String photo;
  String id;
  String breed;
  String color;
  String size;
  String type;
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
    this.type,
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
        type: json['type'],
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
      'photo': this.photo,
      'breed': this.breed,
      'color': this.color,
      'size': this.size,
      'weight': this.weight,
      'age': this.age,
      'sex': this.sex,
      'medicates': this.medicates,
      'diseases': this.disease,
      'owner': this.owner.toMap(),
      'type': this.type,
    });
  }

}