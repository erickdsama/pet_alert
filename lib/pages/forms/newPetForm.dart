import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_alert/bloc/auth/auth_bloc.dart';
import 'package:pet_alert/bloc/auth/auth_state.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/media_repo.dart';
import 'package:pet_alert/styles.dart';
import 'package:pet_alert/widgets/MultiSwitch.dart';
import 'package:pet_alert/widgets/TextFormFieldBorder.dart';

class NewPetForm extends StatefulWidget{
  @override
  State<NewPetForm> createState() => _NewPetForm();
}

final _formKey = GlobalKey<FormState>();

class _NewPetForm extends State<NewPetForm> {
  PetBloc petBloc;
  PickedFile _image;
  PetModel _petModel = PetModel();
  MediaRepo mediaRepo;
  _imgFromCamera() async {
    PickedFile image = await ImagePicker().getImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    petBloc = BlocProvider.of<PetBloc>(context);
    mediaRepo = MediaRepo();
    super.initState();
  }

  @override
  void dispose() {
    petBloc?.close();
    super.dispose();
  }

  _imgFromGallery() async {
    PickedFile image = await  ImagePicker().getImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    String fileName = await mediaRepo.uploadFile(image.path);
    _petModel.photo = fileName;
    setState(() {
      _image = image;
      print("image ${_image.path}");
    });
  }

  Widget _showPicker(context) {
    return CupertinoActionSheet(
      title: Text("Subir imagenes"),
      actions: [
        CupertinoActionSheetAction(
          child: Text("Biblioteca"),
          isDefaultAction: true,
          isDestructiveAction: true,
          onPressed: () {
            _imgFromGallery();
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Camara"),
          isDefaultAction: true,
          isDestructiveAction: true,
          onPressed: () {
            _imgFromCamera();
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancelar"),
        onPressed: () {

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _petModel.sex = 1;
    return  Form(
          key: _formKey,
            child: Center(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextInputFormBorder(
                        onSaved: (string) {
                          print("string $string");
                          _petModel.name = string;
                        },
                        inputType: TextInputType.name,
                        label: "Nombre",
                        hint: "Escribe el nombre de tu mascota",
                        suffix: "",
                      ),
                      TextInputFormBorder(
                        onSaved: (string) {
                          _petModel.age = double.parse(string);
                        },
                        inputType: TextInputType.number,
                        label: "Edad",
                        hint: "Escribe la edad de la mascota",
                        suffix: "Años",
                      ),
                      MultiSwitch(
                        title: "Tipo de mascota",
                        buttons: {
                          "dog": Icon(FontAwesome5Solid.dog),
                          "cat": Icon(FontAwesome5Solid.cat),
                        },
                        onSelected: (petType) {
                          _petModel.type = petType == "dog" ? "Perro" : "Gato";
                          print(petType);
                        },
                      ),
                      MultiSwitch(
                        title: "Genero de la mascota",
                        buttons: {
                          "female": Icon(AntDesign.woman),
                          "man": Icon(AntDesign.man),
                        },
                        onSelected: (petSex) {
                          _petModel.sex = petSex == "female" ? 0 : 1;
                        },
                      ),
                      TextInputFormBorder(
                        label: "Raza",
                        hint: "Escribe la raza de tu mascota",
                        suffix: "",
                        onSaved: (breed) {
                          _petModel.breed = breed;
                        },
                      ),
                      TextInputFormBorder(
                        label: "Color",
                        hint: "Ejemplo, Negro Manchas blancas",
                        suffix: "",
                        onSaved: (color) {
                          _petModel.color = color;
                        },
                      ),
                      TextInputFormBorder(
                        label: "Peso",
                        hint: "Peso aproximado",
                        suffix: "Kg",
                        inputType: TextInputType.number,
                        onSaved: (weight) {
                          _petModel.weight = double.parse(weight);
                        },
                      ),
                      TextInputFormBorder(
                        label: "Tamaño",
                        hint: "Grande / Mediano / Chico ",
                        suffix: "Kg",
                        inputType: TextInputType.number,
                        onSaved: (size) {
                          _petModel.size = size;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Si tu mascota tiene alguna discapacidad o problema congénito, descríbelo", style: labels,),
                            CupertinoTextField(
                              maxLines: 2,
                              placeholder: "Ej. Ceguera, epilepsía, sordera",
                              onChanged: (disease) {
                                _petModel.disease = disease;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Si toma algún medicamento especifique", style: labels,),
                            CupertinoTextField(
                              maxLines: 2,
                              placeholder: "Ej. 2 pastillas de X  c/8 horas",
                              onChanged: (medicates) {
                                _petModel.medicates = medicates;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: CupertinoButton(
                            child: Text("Subir fotos"),
                            onPressed: (){
                              showCupertinoModalPopup(context: context, builder: _showPicker);
                            },
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child:Image.file(
                          _image != null ? File(_image.path) : File("assets/images/Snowball_II.png"),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,)
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, stateAuth) {
                          UserModel userModel = stateAuth is AuthenticatedState ? stateAuth.userModel : null;
                          return BlocConsumer<PetBloc, PetState>(
                            builder: (context, state){
                                return CupertinoButton(
                                    child: Text("Enviar ${userModel.id}"),
                                    onPressed: () {
                                      _petModel.owner = userModel;
                                      print("user ${userModel.toJSON()}");
                                      petBloc.add(SavePet(petModel: _petModel));
                                    });
                            },
                            listener: (bloc, state){
                              if(state is SavedPet) {
                                print("Mascota guardad");
                              }  else if (state is ErrorSavingPet) {
                                print("error ");
                              }
                            }
                          );
                        },
                      ),
                      Divider(),
                      SizedBox(
                        height: 40,
                      )
                  ],
                )
              ),
            )
        );
  }

}