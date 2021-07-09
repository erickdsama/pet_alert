import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
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
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dog_cat.png", ),
            colorFilter: ColorFilter.mode(Colors.white.withAlpha(8), BlendMode.dstATop),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter
          )
        ),
        child: CustomScrollView(
          slivers : [
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.transparent,
              border: null,
              largeTitle: Text("Mis Mascotas"),
            ),
            BlocBuilder<PetBloc, PetState>(
                builder: (context, state){
                  if(state is PetsIsLoadedState) {
                    if (state.petsModel.length > 0) {
                      print("ssss ${state.petsModel.length}");
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((ctx, idx) {
                          return Dismissible(
                              movementDuration: Duration(seconds: 2),
                              dragStartBehavior: DragStartBehavior.down,
                              background: Container(color: Colors.redAccent,),
                              direction: DismissDirection.endToStart,
                              key: Key(state.petsModel[idx].id),
                              onDismissed: (direction) {
                              },
                              child: ListPetItem(petModel: state.petsModel[idx],),
                          );
                        // }, childCount: 10)
                        }, childCount: state.petsModel.length)
                    );
                    } else {
                      return notPets(context);
                    }
                  } else {
                    return notPets(context);
                  }
              }),
          ],
        ),
      )
    );
  }
}