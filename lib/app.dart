import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_colors.dart';
import 'package:recappture2/pages/home/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: MyColors.brightness,
        primarySwatch: MyColors.primary,
        primaryColor: MyColors.primary, // could be of swatch !== 500 || in dark theme
        accentColor: MyColors.accent,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        toggleableActiveColor: MyColors.accent,
      ),
      home: Home(),
    );
  }
}
