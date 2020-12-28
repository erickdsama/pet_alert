import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/widgets/list_pet_item.dart';

import '../styles.dart';


class MyPets extends StatelessWidget {


  Widget notPets(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child:
            Image.asset("assets/images/logo.png", color: Colors.grey, width: 100, fit: BoxFit.fitWidth,),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text("oh! \n No hay mascotas registradas", style: descList, textAlign: TextAlign.center,),
          ),
        ),
        CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MaterialIcons.add, size: 30,),
              Text("Agregar")
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/newPet', arguments: {});

          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(

        middle: Text("Mis mascotas"),
        trailing: CupertinoButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/newPet', arguments: {});
          },
        ),
      ),
      child: BlocBuilder<PetBloc, PetState>(
          builder: (context, state){
            print("dsalkjdlkasjldkjaslkdjlksajdlkasjdlkajlkjklsajdklsaj $state");
            if(state is PetsIsLoadedState) {
              if (state.petsModel.length > -1) {
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                    itemCount: state.petsModel.length,
                    itemBuilder: (BuildContext ctx, int idx) {
                      return Dismissible(
                        movementDuration: Duration(seconds: 2),
                        dragStartBehavior: DragStartBehavior.down,
                        background: Container(color: Colors.redAccent,),
                        direction: DismissDirection.endToStart,
                        key: Key(state.petsModel[idx].id),
                        onDismissed: (direction) {
                        },
                        child: ListPetItem(petModel: state.petsModel[idx],)
                      );
                    });
              } else {
                return notPets(context);
              }
            } else {
              return notPets(context);
            }
          })
    );
  }
}