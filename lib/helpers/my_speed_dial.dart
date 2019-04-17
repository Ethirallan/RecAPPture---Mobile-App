import 'package:flutter/material.dart';
import 'package:recappture2/pages/gallery/gallery_slide.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'package:recappture2/helpers/my_colors.dart';


// Custom floating action button for adding images which on press reveals 2 additional buttons

class MySpeedDial extends StatefulWidget {
  @override
  State createState() => new MySpeedDialState();
}

class MySpeedDialState extends State<MySpeedDial> with TickerProviderStateMixin {
  AnimationController _controller;

  static const List<IconData> icons = const [ Icons.add_a_photo, Icons.photo_library ];

  Widget build(BuildContext context) {
    Color backgroundColor = MyColors.green;
    Color foregroundColor = Colors.white;
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(icons.length, (int index) {
        Widget child = Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - index / icons.length / 2.0, curve: Curves.easeOut
              ),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: true,
              child: Icon(icons[index], color: foregroundColor),
              onPressed: () {
                if (index == 0) {
                  GallerySlideState().getImage(ImageSource.camera, context);
                } else {
                  GallerySlideState().getImage(ImageSource.gallery, context);
                }
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
        );
        return child;
      }).toList()..add(
        FloatingActionButton(
          backgroundColor: backgroundColor,
          heroTag: null,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: Icon(_controller.isDismissed ? Icons.add : Icons.close, size: 30, color: Colors.white,),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
      ),
    );
  }
}