import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_widgets.dart';
import 'package:recappture2/helpers/my_colors.dart';
import 'package:recappture2/helpers/validators.dart';
import 'package:recappture2/helpers/my_geolocator.dart';
import 'package:recappture2/helpers/my_dialogs.dart';
import 'package:recappture2/model/my_data.dart';
import 'package:recappture2/pages/home/home.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSlide extends StatefulWidget {
  @override
  LocationSlideState createState() => LocationSlideState();
}

class LocationSlideState extends State<LocationSlide> with AutomaticKeepAliveClientMixin<LocationSlide> {

  static GlobalKey<FormState> locationKey = new GlobalKey<FormState>();
  static TextEditingController locationCtrl = new TextEditingController();
  bool autoVal = false;
  bool isGettingLocation = false;

  //function which is being called from navigation model
  static bool validateLocation() {
    if (locationKey.currentState.validate()) {
      locationKey.currentState.save();
      return true;
    }
    return false;
  }

  /*
    - checks location status:
      - denied:
        - ask user for permission
        - check if permission is granted -> get location if yes
      - enabled -> get location
      - disabled -> popup notifying user that GPS is turned off
   */
  void getLocationDetails() async {
    String res = await getLocationStatus();
    if (res == 'Denied') {
      await PermissionHandler().requestPermissions([PermissionGroup.location]);
      if (await PermissionHandler().checkPermissionStatus(PermissionGroup.location) == PermissionStatus.granted) {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return locationDialog;
            });
        locationCtrl.text = await getLocation();
        Navigator.pop(context);
      }
    } else if (res == 'Enabled') {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return locationDialog;
          });
      locationCtrl.text = await getLocation();
      Navigator.pop(context);
    } else if (res == 'Disabled') {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return openLocationSettings(context);
        },
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Lokacija: ' + res),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Form(
        key: locationKey,
        autovalidate: autoVal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MyImage(
              height: 100,
              asset: 'assets/location.png',
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: MyText(
                text: 'Lokacija odsluženega lesa',
                size: 25,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyInput(
              ctrl: locationCtrl,
              hint: 'Ulica in hišna št., kraj',
              type: TextInputType.text,
              inputAction: TextInputAction.go,
              onFieldSubmitted: (String val) {
                FocusScope.of(context).requestFocus(new FocusNode());
                HomeState.navigationModel.next(context);
              },
              onEditingComplete: () => setState(() {
                    autoVal = true;
                  }),
              onSave: (String val) => MyData.location = val,
              validator: MyValidators.validateLocation,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: MyText(
                text: 'Poišči mojo lokacijo',
                size: 22,
                color: MyColors.grey,
              ),
            ),
            MyImgBtn(
              height: 45,
              asset: 'assets/get_location_green.png',
              fun: getLocationDetails,
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
