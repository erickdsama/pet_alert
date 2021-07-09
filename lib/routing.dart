import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/pages/alert_detail.dart';
import 'package:pet_alert/pages/chat.dart';
import 'package:pet_alert/pages/chat_list.dart';
import 'package:pet_alert/pages/my_alerts.dart';
import 'package:pet_alert/pages/my_pets.dart';
import 'package:pet_alert/pages/new_pet.dart';
import 'package:pet_alert/pages/pet_detail.dart';
import 'package:pet_alert/repo/AlertRepo.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import 'package:pet_alert/repo/user_repo.dart';

import 'pages/login.dart';


AlertRepo alertRepo = AlertRepo();
PetRepo petRepo = PetRepo();
UserRepo userRepo = UserRepo();

ChatBloc chatBloc = ChatBloc(userRepo);
AlertBloc alertBloc = AlertBloc(alertRepo: alertRepo);

class Routing{

  void init() {

  }

  Route<dynamic>generateRouting(settings) {
    final args = settings.arguments;
    switch(settings.name) {
      case '/petDetail':
        PetModel petModel;
        print("args ${args}");
        if (args is PetModel) {
          petModel = args;
        }
        return CupertinoPageRoute(

            builder: (_) => new PetDetailPage(petModel: petModel,)
        );
        break;
      case '/newPet':
        return CupertinoPageRoute(
            builder: (_) => new NewPetPage()
        );
        break;
      case '/myPets':
        return CupertinoPageRoute(
            builder: (_) {
               return MyPets();
            }
        );
      case '/myAlerts':
        return CupertinoPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: alertBloc,
                child: MyAlerts(),
              );
            }
        );
        break;
      case '/myChats':
        return CupertinoPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: chatBloc,
                child: ChatsList(),
              );
            }
        );
        break;
      case '/chat':
        ChatModel chatModel;
        if (args is Map) {
          if (args.containsKey("data")) {
            chatModel = args["data"];
          }
        }
        return CupertinoPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: chatBloc,
                child: Chat(chatModel: chatModel,),
              );
            }
        );
        break;
      case '/alertDetail':
        AlertModel alertModel;
        if (args is Map) {
          if (args.containsKey("data")) {
            alertModel = args["data"];
          }
        }
        return CupertinoPageRoute(
            builder: (_) => new AlertDetailPage(alertModel: alertModel,)
        );
        break;
      case '/insureData':
        break;
      default:
        return CupertinoPageRoute(
            builder: (_) => new LoginPage()
        );
    }
  }
  @override
  void dispose() {
    chatBloc.close();
    alertBloc?.close();
  }
}