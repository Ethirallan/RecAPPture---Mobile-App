import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_widgets.dart';
import 'package:recappture2/helpers/my_colors.dart';
import 'package:recappture2/helpers/validators.dart';
import 'package:recappture2/model/my_data.dart';
import 'package:recappture2/pages/home/home.dart';

class ContactSlide extends StatefulWidget {
  @override
  ContactSlideState createState() => ContactSlideState();
}

class ContactSlideState extends State<ContactSlide> with AutomaticKeepAliveClientMixin<ContactSlide> {

  static bool autoValEmail = false;
  static bool autoValPhone = false;
  static GlobalKey<FormState> contactKey = new GlobalKey<FormState>();
  final FocusNode phoneNode = new FocusNode(); //for changing focus from one input to the another

  //function which is being called from navigation model
  static bool validateContacts() {
    if (contactKey.currentState.validate()) {
      contactKey.currentState.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Form(
        key: contactKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MyImage(
              height: 40,
              asset: 'assets/email.png',
            ),
            MyInputWithLabel(
              label: 'Vnesite email',
              autoVal: autoValEmail,
              inputAction: TextInputAction.next,
              onFieldSubmitted: (String val) => FocusScope.of(context).requestFocus(phoneNode),
              onEditingComplete: () =>
              setState(() {
                autoValEmail = true;
              }),
              type: TextInputType.emailAddress,
              validator: MyValidators.validateEmail,
              onSave: (String val) => MyData.email = val,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 40),
              child: MyText(
                text: 'in po želji še',
                size: 22,
                color: MyColors.grey,
              ),
            ),
            MyImage(
              height: 40,
              asset: 'assets/call.png',
            ),
            MyInputWithLabel(
              label: 'Vnesite telefon',
              type: TextInputType.phone,
              inputAction: TextInputAction.go,
              autoVal: autoValPhone,
              focusNode: phoneNode,
              onFieldSubmitted: (String val) {
                FocusScope.of(context).requestFocus(new FocusNode());
                HomeState.navigationModel.next(context);
              },
              onEditingComplete: () =>
                  setState(() {
                    autoValPhone = true;
                  }),
              validator: MyValidators.validatePhone,
              onSave: (String val) => MyData.phone = val,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 2),
              child: MyText(
                text: 'Varnostno opozorilo',
                size: 22,
                color: MyColors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyText(
              text: 'Vaši podatki bodo strogo varovani. Uporabili jih bomo le za obveščanje o naši odločitvi in za organizacijo prevoza.',
              size: 16,
              color: MyColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // makes sure that the slide is not being rebuild every time
  @override
  bool get wantKeepAlive => true;
}
