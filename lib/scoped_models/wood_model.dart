import 'package:scoped_model/scoped_model.dart';
import 'package:recappture2/model/my_data.dart';
import 'package:recappture2/pages/home/home.dart';
import 'package:flutter/material.dart';

/*
Scoped model for wood quiz
  - page controller for switching pages-questions (showing different pairs of images)
  - showing the 'next' button if quiz is done
  - keep track of the turn and counters for deciduous and coniferous
  - functions for incrementing counters, saving answers (quiz1 ... quiz3) and selecting final value - woodType
 */
class WoodModel extends Model {
  int _myTurn = 0;
  int _deciduousCount = 0;
  int _coniferousCount = 0;

  PageController woodCtrl = new PageController(initialPage: 0);

  int get turn => _myTurn;

  //listavec
  void addDeciduous(BuildContext context) {
    if (_myTurn < 2) {
      //setQuizAnswers -> 0 igalvec, 1 listavec
      if (_myTurn == 0) {
        MyData.quiz1 = 1;
      } else if (_myTurn == 1) {
        MyData.quiz2 = 1;
      }
      _myTurn++;
      _deciduousCount++;
      woodCtrl.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
    } else if (_myTurn == 2) {
      if (MyData.woodType == null) {
        MyData.quiz3 = 1;
        _deciduousCount++;
        if (_deciduousCount > _coniferousCount) {
          MyData.woodType = 1;
        } else {
          MyData.woodType = 0;
        }
        _myTurn++;
        woodCtrl.nextPage(duration: Duration(milliseconds: 100), curve: Curves.linear);
        HomeState.navigationModel.setBtnVisibility(true);
        HomeState.navigationModel.next(context);
      }
    }
  }

  //iglavec
  void addConiferous(BuildContext context) {
    if (_myTurn < 2) {
      //setQuizAnswers -> 0 igalvec, 1 listavec
      if (_myTurn == 0) {
        MyData.quiz1 = 0;
      } else if (_myTurn == 1) {
        MyData.quiz2 = 0;
      }
      _myTurn++;
      _coniferousCount++;
      woodCtrl.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
    } else if (_myTurn == 2) {
      if (MyData.woodType == null) {
        MyData.quiz3 = 0;
        _coniferousCount++;
        if (_deciduousCount > _coniferousCount) {
          MyData.woodType = 1;
        } else {
          MyData.woodType = 0;
        }
        _myTurn++;
        woodCtrl.nextPage(duration: Duration(milliseconds: 100), curve: Curves.linear);
        HomeState.navigationModel.setBtnVisibility(true);
        HomeState.navigationModel.next(context);
      }
    }
  }
}