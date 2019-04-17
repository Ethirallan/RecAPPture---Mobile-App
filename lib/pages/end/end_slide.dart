import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_widgets.dart';
import 'package:recappture2/helpers/my_colors.dart';

class EndSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MyText(
            text: 'HVALA',
            size: 50,
            color: MyColors.green,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: MyText(
              text: 'Vaši podatki so v obdelavi. Povratne informacije boste dobili najkasneje v roku treh delovnih dni.',
              size: 22,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
