

import 'package:pet_alert/models/PetModel.dart';

class AlertModel{
  final lostPoint;
  final description;
  PetModel pet;
  final pet_id;
  int id;
  String lost_date;


  AlertModel({this.lostPoint, this.description, this.pet, this.pet_id, this.lost_date});

  factory AlertModel.fromJSON(Map<String, dynamic> json) {
    return AlertModel(
      description: json["description"],
      lostPoint: json["lost_point"],
      pet: PetModel.fromJSON(json["pet"]),
      lost_date: json["date_registered"]
    );
  }

}