import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:recappture2/model/my_data.dart';
import 'package:recappture2/environment_variables.dart';

//Posting data to the server, onError return false
Future<bool> sendDataToTheServer() async {
  var url;
  var myData;
  Map data;
  bool result = true;

  //Send user___________________________________________________________________________
  url = '$api/user';

  data = {
    'email': MyData.email,
    'phone_number': MyData.phone
  };

  await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(data)
  ).then((res) {
    myData = jsonDecode(res.body);
    MyData.userId = myData['insertId'];
  }).catchError((err) {
    result = false;
  });

  if (!result) {
    return result;
  }

  //Send order___________________________________________________________________________
  url = '$api/order/';
  data = {
    'user_id': MyData.userId,
    'address': MyData.location,
    'lat': MyData.lat != null ? MyData.lat : 0,
    'lng': MyData.lng != null ? MyData.lng : 0,
    'kub': MyData.quantity,
    'wood_type': MyData.woodType,
  };
  await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(data)).then((res) {
    myData = jsonDecode(res.body);
    MyData.orderId = myData['message']['insertId'];
  }).catchError((err) {
    result = false;
  });

  if (!result) {
    return result;
  }

  //send quiz___________________________________________________________________________
  url = '$api/quiz/';
  data = {
    'order_id': MyData.orderId,
    'q1': MyData.quiz1,
    'q2': MyData.quiz2,
    'q3': MyData.quiz3,
  };

  await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(data)).then((res) {
  }).catchError((err) {
    result = false;
  });

  if (!result) {
    return result;
  }

  //sending photos___________________________________________________________________________
  url = '$api/image/';
  String orderId = MyData.orderId.toString();

  if (MyData.photoList[0] != '') {
    String base64Image = base64Encode(File(MyData.photoList[0]).readAsBytesSync());
    String photo = 'data:image/jpeg;base64,' + base64Image;

    await http.post(url, body: {
      'order_id': orderId,
      'order_img_base64': photo
    }).then((res) {
      result = true;
    }).catchError((err) {
      result = false;
    });
  }
  if (!result) {
    return result;
  }
  if (MyData.photoList[1] != '') {
    String base64Image = base64Encode(File(MyData.photoList[1]).readAsBytesSync());
    String photo = 'data:image/jpeg;base64,' + base64Image;
    await http.post(url, body: {
      'order_id': orderId,
      'order_img_base64': photo
    }).then((res) {
      result = true;
    }).catchError((err) {
      result = false;
    });
  }
  if (!result) {
    return result;
  }
  if (MyData.photoList[2] != '') {
    String base64Image = base64Encode(File(MyData.photoList[2]).readAsBytesSync());
    String photo = 'data:image/jpeg;base64,' + base64Image;
    await http.post(url, body: {
      'order_id': orderId,
      'order_img_base64': photo
    }).then((res) {
      result = true;
    }).catchError((err) {
      result = false;
    });
  }
  return result;
}

