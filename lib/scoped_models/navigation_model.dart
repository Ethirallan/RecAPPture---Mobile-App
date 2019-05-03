import 'package:recappture2/helpers/my_colors.dart';
import 'package:recappture2/model/my_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_dialogs.dart';
import 'dart:io';
import 'package:recappture2/pages/location/location_slide.dart';
import 'package:recappture2/pages/contacts/contacts_slide.dart';
import 'package:recappture2/pages/quantity/quantity_slide.dart';
import 'package:recappture2/helpers/my_http_requests.dart';
import 'package:recappture2/pages/wood/wood_slide.dart';
import 'package:connectivity/connectivity.dart';
import 'package:recappture2/helpers/my_geolocator.dart';


/*
Scoped model for navigation of slides
  - controlling the page view (on home page)
  - showing/hiding 'next' button
  - changing text on the 'next' button
 */
class NavigationModel extends Model {

  final PageController navigationCtrl = new PageController(initialPage: 0);
  int get page => navigationCtrl.page.round();

  bool _showBtn = false;
  bool get showBtn => _showBtn;

  void setBtnVisibility(bool myBool) {
    _showBtn = myBool;
    notifyListeners();
  }

  String nextText = 'NAPREJ';

  void setNextText(String text) {
    nextText = text;
    notifyListeners();
  }

  //Checks which pages is displayed and act accordingly
  void next(BuildContext context) async {
    if (page == 0 || page == 1) {
      //button is show if there is a photo otherwise can not go forward
      if (showBtn) {
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 2) {
      //if location input field is valid navigate to the next slide
      if (LocationSlideState.validateLocation()) {
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 3) {
      //if quantity input field is valid navigate to the next slide
      if (QuantitySlideState.validateQuantity()) {
        //hide btn if quiz is not complete
        if (WoodSlideState.woodModel.turn < 3) {
          _showBtn = false;
        }
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 4) {
      //if quiz is completed the button is shown
      if (showBtn) {
        nextText = 'POŠLJI';
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 5) {
      //if contacts input fields are valid navigate check if there is connection; if yes then display data in popup else display networkDialog
      if (ContactSlideState.validateContacts()) {
        if (await checkConnection()) {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext ctx) {
              return showDataDialog(ctx, context);
            },
          );
        } else {
          networkDialog(context);
        }
      }
    } else if (page == 6) {
      exit(0);
    }
    notifyListeners();
  }

  //Checks which pages is displayed and act accordingly
  void goBack(BuildContext context) {
    if (page == 0) {
      //show exit dialog
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return exitDialog(context);
        },
      );
    } else if (page == 4) {
      //if quiz is not complete show btn on prev slide
      if (!showBtn) {
        _showBtn = true;
      }
      FocusScope.of(context).requestFocus(new FocusNode()); // dismiss keyboard
      navigationCtrl.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else if (page == 6) {
      //last slide -> cannot go back
      return;
    } else {
      //navigate to the previous slide
      FocusScope.of(context).requestFocus(new FocusNode()); // dismiss keyboard
      navigationCtrl.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      nextText = 'NAPREJ';
    }
    notifyListeners();
  }

  /*
  Conformation dialog before posting to the server
    - onPress:
      - shows loading pop
      - starts posting data to the server
      - dismiss loading pop
      - check if there was an error: if so display popup else navigate to the last slide and change button text
   */
  Widget showDataDialog(BuildContext ctx, context) {
    //Transforming data values to strings that user will understand
    String phone = MyData.phone.isNotEmpty ? MyData.phone : '/';
    String wood = MyData.woodType == 1 ? 'listavec' : 'iglavec';

    return AlertDialog(
      title: Text('Želite poslati naslednje podatke?', style: TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            myRow('Lokacija', MyData.location),
            myRow('Količina', MyData.quantity.toString() + ' m\u00B3'),
            myRow('Vrsta lesa', wood),
            myRow('Email', MyData.email),
            myRow('Telefon', phone),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'PREKLIČI',
            style: TextStyle(color: MyColors.green),
          ),
          onPressed: () {
            Navigator.pop(ctx);
          },
        ),
        FlatButton(
          child: Text(
            'POŠLJI',
            style: TextStyle(color: MyColors.green),
          ),
          onPressed: () async {
            Navigator.pop(ctx);
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return loadingDialog;
              },
            );
            if (MyData.lat == null) {
              var coordinates = await getCoordinates(MyData.location);
              MyData.lat = coordinates.first.position.latitude;
              MyData.lng = coordinates.first.position.longitude;
              print(MyData.lat);
              print(MyData.lng);
            }
            bool done = await sendDataToTheServer();
            Navigator.pop(context);
            if (done) {
              navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
              nextText = 'IZHOD';
              notifyListeners();
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return onErrorDialog(context);
                },
              );
            }
          },
        ),
      ],
    );
  }

  //Row for displaying data inside showDataDialog(); (label: + value)
  Widget myRow(String title, text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title: ',
          style: TextStyle(color: MyColors.grey, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: MyColors.grey,),
          ),
        ),
      ],
    );
  }

  //Checks if device is connected to wifi or mobile data (but not if it has internet connection!)
  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}