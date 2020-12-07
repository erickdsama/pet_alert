
class PetModel{
  final name;
  final photo;
  final id;
  final breed;

  PetModel(this.name, this.photo, this.id, this.breed);

  factory PetModel.fromJSON(Map<String, dynamic> json) {
    return PetModel(json['name'], json['photo'], json['breed'], json['id']);
  }

}