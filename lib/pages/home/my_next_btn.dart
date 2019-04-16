import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_colors.dart';

class NextBtn extends StatelessWidget {
  NextBtn({this.fun, this.text});
  final VoidCallback fun;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: RaisedButton(
          color: MyColors.green,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          onPressed: fun,
        ),
      ),
    );
  }
}