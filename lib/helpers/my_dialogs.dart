import 'package:flutter/material.dart';
import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:recappture2/helpers/my_colors.dart';
import 'dart:io';
import 'package:app_settings/app_settings.dart';

Widget loadingDialog = WillPopScope(
  onWillPop: () async {
    return new Future(() => false);
  },
  child: AlertDialog(
    content: Row(
      children: <Widget>[
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.green),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "Prosimo počakajte ...",
            style: TextStyle(
              color: MyColors.grey,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    ),
  ),
);

void networkDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Težave pri povezovanju',
          style: TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),
        ),
        content: Text('Želite odpreti nastavitve za WIFI?',style: TextStyle(color: MyColors.grey),),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ne'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openWIFISettings();
            },
            child: Text('Da'),
          ),
        ],
      );
    },
  );
}

Widget onErrorDialog(BuildContext context) {
  return AlertDialog(
    title: Text(
      'Težave pri povezovanju',
      style: TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),
    ),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(
            'Prosimo poskusite ponovno. V primeru ponovnih težav vas prosimo, da poskusite ponovno kasneje.',
            style: TextStyle(color: MyColors.grey),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'ZAPRI',
          style: TextStyle(color: MyColors.green),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget locationDialog = WillPopScope(
  onWillPop: () async {
    return new Future(() => false);
  },
  child: AlertDialog(
    content: Row(
      children: <Widget>[
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.green),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "Iskanje lokacije ...",
            style: TextStyle(
              color: MyColors.grey,
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    ),
  ),
);

Widget exitDialog(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      return new Future(() => false);
    },
    child: AlertDialog(
      title: Text(
        'Izhod',
        style: TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Želite zapreti aplikacijo?',
              style: TextStyle(color: MyColors.grey),
            ),
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
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            'POTRDI',
            style: TextStyle(color: MyColors.green),
          ),
          onPressed: () {
            exit(0);
          },
        ),
      ],
    ),
  );
}

Widget openLocationSettings(BuildContext context) {
  openSettingsMenu() async {
    var resultSettingsOpening = false;
    try {
      resultSettingsOpening = await AccessSettingsMenu.openSettings(
          settingsType: 'ACTION_LOCATION_SOURCE_SETTINGS');
    } catch (e) {
      resultSettingsOpening = false;
    }
    return resultSettingsOpening;
  }


  return AlertDialog(
    title: Text(
      'Lokacija onemogočena',
      style: TextStyle(color: MyColors.green, fontWeight: FontWeight.bold),
    ),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(
            'Želite odpreti nastavitve lokacije?',
            style: TextStyle(color: MyColors.grey),
          ),
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
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text(
          'ODPRI',
          style: TextStyle(color: MyColors.green),
        ),
        onPressed: () {
          openSettingsMenu();
          Navigator.pop(context);
        },
      ),
    ],
  );
}
