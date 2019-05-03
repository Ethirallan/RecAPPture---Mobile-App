import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_colors.dart';

// A file with custom widgets used for building pages

class MyText extends StatelessWidget {
  MyText({this.text, this.size, this.fontWeight, this.color});
  final String text;
  final double size;
  final FontWeight fontWeight; //bold, italic ...
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
      ),
    );
  }
}

class MyImgBtn extends StatelessWidget {
  MyImgBtn({this.height, this.asset, this.fun});
  final double height;
  final String asset;
  final VoidCallback fun;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        height: height,
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class MyImage extends StatelessWidget {
  MyImage({this.height, this.asset});
  final double height;
  final String asset;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
      ),
    );
  }
}

class MyInput extends StatelessWidget {
  MyInput({this.hint, this.type, this.onSave, this.validator, this.maxLength, this.ctrl, this.onEditingComplete, this.inputAction, this.onFieldSubmitted});
  final String hint;
  final TextInputType type;
  final Function onSave;
  final Function validator;
  final int maxLength;
  final TextEditingController ctrl;
  final Function onEditingComplete;
  final TextInputAction inputAction;
  final Function onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width * 3/5,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        onSaved: onSave,
        controller: ctrl,
        validator: validator,
        maxLength: maxLength,
        onEditingComplete: onEditingComplete,
        keyboardType: type,
        textInputAction: inputAction,
        onFieldSubmitted: onFieldSubmitted,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 22.0,
            color: Colors.black
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(
                color: MyColors.grey,
                fontSize: 20.0
            ),
            hintText: this.hint
        ),
      ),
    );
  }
}

class MyInputWithLabel extends StatelessWidget {
  MyInputWithLabel({this.label, this.type, this.onSave, this.focusNode, this.validator, this.onEditingComplete, this.autoVal, this.inputAction, this.onFieldSubmitted});
  final String label;
  final TextInputType type;
  final Function onSave;
  final Function validator;
  final Function onEditingComplete;
  final bool autoVal;
  final TextInputAction inputAction;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 3/5,
      child: TextFormField(
        onSaved: onSave,
        validator: validator,
        focusNode: focusNode,
        textInputAction: inputAction,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: type,
        textAlign: TextAlign.center,
        autovalidate: autoVal,
        onEditingComplete: onEditingComplete,
        style: TextStyle(
            fontSize: 22.0,
            color: Colors.black
        ),
        decoration: InputDecoration(
            labelStyle: TextStyle(
              color: MyColors.green,
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            ),
            labelText: this.label
        ),
      ),
    );
  }
}