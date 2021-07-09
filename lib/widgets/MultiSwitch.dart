

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../globals.dart';

class MultiSwitch extends StatefulWidget {
  final Function(String) onSelected;
  final Map<String, dynamic> buttons;
  final String title;

  const MultiSwitch({Key key, this.onSelected, this.buttons, this.title}) : super(key: key);

  @override
  _MultiSwitchState createState() => _MultiSwitchState(onSelected: onSelected, buttons: buttons);
}

class _MultiSwitchState extends State<MultiSwitch> {
  final Map<String, dynamic> buttons;
  List<Widget> widgetIconButtons;
  List<bool> mapOfValues = [];
  final Function(String) onSelected;

  _MultiSwitchState({this.onSelected, this.buttons});

  @override
  void initState() {
    widgetIconButtons = buttons.values.map<Widget>((e) => e).toList();
    buttons.keys.forEach((element) {
      mapOfValues.add(false);
    });
    mapOfValues[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Text("${widget.title}"),
          ),
          Row(
            children: [
              ToggleButtons(
                children: widgetIconButtons,
                isSelected: mapOfValues,
                selectedColor: Colors.white,
                fillColor: primary,
                color: Colors.grey,
                selectedBorderColor: primary,
                borderColor: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                onPressed: (index) {
                  int anotherIndex = index == 1 ? 0 : 1;
                  setState(() {
                    mapOfValues[anotherIndex] = mapOfValues[index];
                    mapOfValues[index] = !mapOfValues[index];
                  });
                  mapOfValues.toList().asMap().forEach((index, element) {
                    if(element == true) {
                      print(buttons.keys.toList());
                      onSelected(buttons.keys.toList()[index]);

                    }
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}