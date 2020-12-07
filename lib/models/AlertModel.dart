

class AlertModel{
  final lostPoint;
  final description;
  final pet;
  final pet_id;
  final lost_date;


  AlertModel(this.lostPoint, this.description, this.pet, this.pet_id, this.lost_date);

  factory AlertModel.fromJSON(Map<String, dynamic> json) {
    return AlertModel(json['lost_point'], json['description'], json['pet'], json['pet_id'], json['date_registered']);
  }

}