import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_colors.dart';

class MyBackButton extends StatelessWidget {
  MyBackButton({this.fun});
  final VoidCallback fun;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: 40,
        color: MyColors.grey,
      ),
      onPressed: fun,
    );
  }
}