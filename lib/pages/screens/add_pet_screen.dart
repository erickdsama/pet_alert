import 'package:flutter/cupertino.dart';

class AddPetScreen extends StatelessWidget {
  static const String id = 'AddPetScreen';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false // here!
      ),
      child: GestureDetector(
        child: Center(
          child: Text('AddPetScreen',),
        ),
      ),
    );
  }
}