import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_alert/styles.dart';

class ListCommentItem extends StatelessWidget {
  final String imagePath;
  final String username;
  final String comment;
  final String date;

  ListCommentItem({Key key,
    @required this.imagePath,
    @required this.username,
    @required this.comment,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    Map<String, String> arguments = {
//      "imagePath": this.imagePath,
//      "petName": this.petName,
//      "petDescription": this.petDescription,
//      "missingDate": this.missingDate,
//    };

    return GestureDetector(
      onTap: () => {
//        Navigator.pushNamed(context, '/petDetail', arguments: {"data":null})
      },
      child: Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.asset(this.imagePath, height: 50, width: 50, fit: BoxFit.fill )
                            )
                        )
                    )
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container( child: Text("${this.username}", style: titleList,)),
                      Container( child: Text("${this.date}", style: dateList,)),
                      Container( child: Text("${this.comment}", style: textList,))
                    ],
                  ),
                ),
              ],
            ),
          )
      )
    );
  }
}