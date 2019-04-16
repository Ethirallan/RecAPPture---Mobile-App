import 'package:recappture2/helpers/my_colors.dart';
import 'package:recappture2/model/my_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_dialogs.dart';
import 'dart:io';
import 'package:recappture2/pages/location/location_slide.dart';
import 'package:recappture2/pages/contacts/contacts_slide.dart';
import 'package:recappture2/pages/quantity/quantity_slide.dart';
import 'package:recappture2/helpers/my_http_calls.dart';
import 'package:recappture2/pages/wood/wood_slide.dart';
import 'package:connectivity/connectivity.dart';

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

  void next(BuildContext context) async {
    if (page == 0 || page == 1) {
      if (showBtn) {
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 2) {
      if (LocationSlideState.validateLocation()) {
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 3) {
      if (QuantitySlideState.validateQuantity()) {
        //hide btn if quiz is not complete
        if (WoodSlideState.woodModel.turn < 3) {
          _showBtn = false;
        }
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 4) {
      if (showBtn) {
        nextText = 'POŠLJI';
        navigationCtrl.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    } else if (page == 5) {
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

  void goBack(BuildContext context) {
    if (page == 0) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return exitDialog(context);
        },
      );
      //if quiz is not complete show btn on prev slide
    } else if (page == 4) {
      if (!showBtn) {
        _showBtn = true;
      }
      navigationCtrl.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else if (page == 6) {
      return;
    } else {
      FocusScope.of(context).requestFocus(new FocusNode());
      navigationCtrl.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
      nextText = 'NAPREJ';
    }
    notifyListeners();
  }

  Widget showDataDialog(BuildContext ctx, context) {

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

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}