

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class BoxCharacteristicItem extends StatelessWidget {

  final String title;
  final String desc;
  final IconData icon;
  String suffix = "";

  BoxCharacteristicItem({this.title, this.desc, this.suffix, this.icon});

  @override
  Widget build(BuildContext context) {
    String suffix = this.suffix != null ? " ${this.suffix}": "";
    return Container(
      width: 100,
      height: 70,
      child: Container(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(icon, color: accentColor,),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${title}", style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 16)),
                Text("$desc$suffix", style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12),),
              ],
            ),
          ],
        ),
      ),
    );
  }

}