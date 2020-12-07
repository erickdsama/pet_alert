

import 'package:flutter/cupertino.dart';

import '../styles.dart';

class IconText extends StatelessWidget {

  final IconData iconData;
  final String text;

  const IconText({Key key, @required this.iconData, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: [
          Icon(iconData),
          Text(""),
          Text("$text", textAlign: TextAlign.center, style: subText,)
        ]
    );
  }
}