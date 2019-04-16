import 'package:flutter/material.dart';

class MLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 4.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        'assets/m_sora_logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}