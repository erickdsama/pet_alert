import 'package:flutter/cupertino.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/pages/alert_detail.dart';
import 'package:pet_alert/pages/chat_list.dart';
import 'package:pet_alert/pages/main_page.dart';
import 'package:pet_alert/pages/my_alerts.dart';
import 'package:pet_alert/pages/my_pets.dart';
import 'package:pet_alert/pages/new_pet.dart';
import 'package:pet_alert/pages/pet_detail.dart';
import 'package:pet_alert/services/AuthService.dart';

import 'pages/login.dart';

class Routing{
  static Route<dynamic>generateRouting(settings) {

    final args = settings.arguments;
    switch(settings.name) {
      case '/listPets':
        return CupertinoPageRoute(
            builder: (_) => new MainPage()
        );
        break;
      case '/petDetail':
        AlertModel alertModel;
        if (args is Map) {
          if (args.containsKey("data")) {
            alertModel = args["data"];
          }
        }
        return CupertinoPageRoute(
            builder: (_) => new PetDetailPage(authService: null, alertModel: alertModel,)
        );
        break;
      case '/newPet':
        return CupertinoPageRoute(
            builder: (_) => new NewPetPage(null)
        );
        break;
      case '/myPets':
        return CupertinoPageRoute(
            builder: (_) => new MyPets()
        );
        break;
      case '/myAlerts':
        return CupertinoPageRoute(
            builder: (_) => new MyAlerts()
        );
        break;
      case '/myChats':
        return CupertinoPageRoute(
            builder: (_) => new ChatsList()
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
            builder: (_) => new LoginPage(authService: new AuthService())
        );
    }
  }

}