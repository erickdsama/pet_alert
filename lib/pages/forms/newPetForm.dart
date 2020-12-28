import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/styles.dart';

class NewPetForm extends StatefulWidget{
  @override
  State<NewPetForm> createState() => _NewPetForm();
}

final _formKey = GlobalKey<FormState>();

class _NewPetForm extends State<NewPetForm> {
  List<bool> _selectedSex = [true, false];
  List<bool> _selectedType = [true, false];

  File _image;
  PetModel _petModel = PetModel();
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
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
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nombre de la mascota", style: labels),
                            TextFormField(
                              onSaved: (cosa){
                                print("primero");
                                _petModel.name = cosa;
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
                            Text("Edad de la mascota", style: labels),
                            TextFormField(
                              decoration: InputDecoration(
                                suffix: Padding(padding: EdgeInsets.all(2), child: Text("Año", style: dateList,)),
                                hintText: "Escribe la edad de la mascota en años"
                              ),
                              onSaved: (edad){
                                _petModel.age = double.parse(edad);
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
                            Text("Tipo de mascota", style: labels),
                            Row(
                              children: [
                                ToggleButtons(
                                  children: [
                                    Icon(FontAwesome5Solid.cat),
                                    Icon(FontAwesome5Solid.dog)
                                  ],
                                  isSelected: _selectedType,
                                  selectedColor: Colors.white,
                                  fillColor: primary,
                                  color: Colors.grey,
                                  selectedBorderColor: primary,
                                  borderColor: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  onPressed: (index) {
                                    setState(() {
                                      print("index $index, $_selectedType");
                                      _selectedType[index] = !_selectedType[index];
                                      print(_selectedType);
                                    });
                                  },


                                ),

                              ],
                            )

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sexo", style: labels),
                            Row(
                              children: [
                                ToggleButtons(
                                  children: [
                                    Icon(AntDesign.man),
                                    Icon(AntDesign.woman)
                                  ],
                                  isSelected: _selectedSex,
                                  selectedColor: Colors.white,
                                  fillColor: primary,
                                  color: Colors.grey,
                                  selectedBorderColor: primary,
                                  borderColor: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  onPressed: (index) {
                                    setState(() {
                                      print("index $index, $_selectedSex");
                                      _petModel.sex = index;
                                      if (index == 0) {
                                        _selectedSex[0] = true;
                                        _selectedSex[1] = false;
                                      } else {
                                        _selectedSex[0] = false;
                                        _selectedSex[1] = true;
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Raza", style: labels),
                            CupertinoTextField(
                              placeholder: "Ej. Husky",
                              onChanged: (breed){
                                _petModel.breed = breed;
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
                            Text("Color", style: labels,),
                            CupertinoTextField(
                              suffix: Padding(padding: EdgeInsets.all(2), child: Text("Año", style: dateList,)),
                              suffixMode: OverlayVisibilityMode.editing,
                              placeholder: "Ej. Negro y manchas blancas",
                              onChanged: (color) {
                                _petModel.color = color;
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
                            Text("Peso", style: labels,),
                            CupertinoTextField(
                              suffix: Padding(padding: EdgeInsets.all(2), child: Text("Año", style: dateList,)),
                              suffixMode: OverlayVisibilityMode.editing,
                              placeholder: "Ej. 2kg",
                              onChanged: (weight) {
                                _petModel.weight = double.parse(weight);
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
                            Text("Tamaño", style: labels,),
                            CupertinoTextField(
                              suffix: Padding(padding: EdgeInsets.all(2), child: Text("Año", style: dateList,)),
                              suffixMode: OverlayVisibilityMode.editing,
                              placeholder: "Ej. Gigante, Grande, mediano, pequeño ",
                              onChanged: (size) {
                                _petModel.size = size;
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
                            Text("Si tu mascota tiene alguna discapacidad o problema congénito, descríbelo", style: labels,),
                            CupertinoTextField(
                              maxLines: 2,
                              suffix: Padding(padding: EdgeInsets.all(2), child: Text("Año", style: dateList,)),
                              suffixMode: OverlayVisibilityMode.editing,
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
                              suffix: Padding(padding: EdgeInsets.all(2), child: Text("Año", style: dateList,)),
                              suffixMode: OverlayVisibilityMode.editing,
                              placeholder: "Ej. 2 pastillas de X cosa c/8 horas",
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
                          _image != null ? _image : File("assets/images/perrito.jpeg"),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,)
                      ),
                      BlocConsumer<PetBloc, PetState>(
                          builder: (context, state){
                            return CupertinoButton(
                                child: Text("Enviar"),
                                onPressed: () {
                                  _formKey.currentState.save();
                                  PetBloc petBloc = BlocProvider.of(context);
                                  petBloc.add(SavePet(petModel: _petModel));
                                });
                            },
                          listener: (bloc, state){

                          }),
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