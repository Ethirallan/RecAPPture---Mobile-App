import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:recappture2/model/my_data.dart';
import 'package:recappture2/pages/home/home.dart';

/*
Scoped model for photo gallery (on second slide)
  - page controller that navigates to the last photo added
  - functions to check if gallery is full/empty aka if there are/are not 3 photos, add image and remove image
 */
class GalleryModel extends Model {
  PageController galleryCtrl = new PageController();

  List<String> _imgList = [
    '',
    '',
    ''
  ];

  List<String> get imgList => _imgList;

  bool checkIfGalleryFull() {
    if (_imgList[0] != '' && _imgList[1] != '' && _imgList[2] != '') {
      return true;
    }
    return false;
  }

  bool checkIfGalleryEmpty() {
    if (_imgList[0] == '' && _imgList[1] == '' && _imgList[2] == '') {
      return true;
    }
    return false;
  }

  void addImage(String path) {
    if (_imgList[0] == '') {
      _imgList[0] = path;
      MyData.photoList[0] = path;
      notifyListeners();
    } else if (_imgList[1] == '') {
      _imgList[1] = path;
      MyData.photoList[1] = path;
      galleryCtrl.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      notifyListeners();
    } else if (_imgList[2] == '') {
      _imgList[2] = path;
      MyData.photoList[2] = path;
      galleryCtrl.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      notifyListeners();
    }

    if (!checkIfGalleryEmpty()) {
      HomeState.navigationModel.setBtnVisibility(true);
      notifyListeners();
    }
  }

  void removeImage(int index) {
    _imgList[index] = '';
    MyData.photoList[index] = '';
    if (checkIfGalleryEmpty()) {
      HomeState.navigationModel.setBtnVisibility(false);
      HomeState.navigationModel.navigationCtrl.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    notifyListeners();
  }
}