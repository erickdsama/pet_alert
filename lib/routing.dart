import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/alert_bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/pages/main_page.dart';
import 'package:pet_alert/pages/my_alerts.dart';
import 'package:pet_alert/pages/my_pets.dart';
import 'package:pet_alert/pages/new_pet.dart';
import 'package:pet_alert/pages/pet_detail.dart';
import 'package:pet_alert/pages/screens/add_pet_screen.dart';
import 'package:pet_alert/repo/AlertRepo.dart';
import 'package:pet_alert/repo/PetRepo.dart';
import 'package:pet_alert/repo/location.dart';
import 'package:pet_alert/services/AuthService.dart';

import 'bloc/location/location_bloc.dart';
import 'pages/login.dart';

class Routing{
  static Route<dynamic>generateRouting(settings) {

    final args = settings.arguments;
    AlertRepo alertRepo = AlertRepo();
    PetRepo petRepo = PetRepo();
    PetBloc petBloc = PetBloc(petRepo);

    switch(settings.name) {
      case '/listPets':
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: [
              BlocProvider<AlertBloc>(
                create: (context) => AlertBloc(alertRepo, locationBloc),
              ),
              BlocProvider<PetBloc>(
                create: (context) => PetBloc(petRepo),
              )
            ], child: MainPage())
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
      case '/insureData':
        break;
      default:
        return CupertinoPageRoute(
            builder: (_) => new LoginPage(authService: new AuthService())
        );
    }
  }

}