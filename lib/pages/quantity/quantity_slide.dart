import 'package:flutter/material.dart';
import 'package:recappture2/helpers/components.dart';
import 'package:recappture2/helpers/my_colors.dart';
import 'package:recappture2/helpers/validators.dart';
import 'package:recappture2/model/my_data.dart';
import 'package:recappture2/pages/home/home.dart';

class QuantitySlide extends StatefulWidget {
  @override
  QuantitySlideState createState() => QuantitySlideState();
}

class QuantitySlideState extends State<QuantitySlide> with AutomaticKeepAliveClientMixin<QuantitySlide> {

  static GlobalKey<FormState> quantityKey = new GlobalKey<FormState>();

  static bool validateQuantity() {
    if (quantityKey.currentState.validate()) {
      quantityKey.currentState.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Form(
        key: quantityKey,
        autovalidate: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MyImage(
              height: 80,
              asset: 'assets/cubicm.png',
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: MyText(
                text: 'Količina odsluženega lesa',
                size: 25,
                color: MyColors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyInput(
              hint: 'V kubičnih m (max 20)',
              type: TextInputType.numberWithOptions(decimal: false),
              onFieldSubmitted: (String val) {
                FocusScope.of(context).requestFocus(new FocusNode());
                HomeState.navigationModel.next(context);
              },
              inputAction: TextInputAction.go,
              maxLength: 2,
              onSave: (String val) => MyData.quantity = int.parse(val),
              validator: MyValidators.validateQuantity,
            ),
          ],
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
