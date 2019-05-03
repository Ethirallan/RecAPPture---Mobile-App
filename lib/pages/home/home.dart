import 'package:flutter/material.dart';
import 'package:recappture2/helpers/my_dialogs.dart';
import 'package:recappture2/pages/home/logo_widget.dart';
import 'package:recappture2/pages/home/my_back_btn.dart';
import 'package:recappture2/pages/camera/camera_slide.dart';
import 'package:recappture2/pages/home/my_next_btn.dart';
import 'package:recappture2/scoped_models/navigation_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:recappture2/pages/end/end_slide.dart';
import 'package:recappture2/pages/quantity/quantity_slide.dart';
import 'package:recappture2/pages/contacts/contacts_slide.dart';
import 'package:recappture2/pages/location/location_slide.dart';
import 'package:recappture2/pages/wood/wood_slide.dart';
import 'package:recappture2/pages/gallery/gallery_slide.dart';

// Main page - scaffold containing a stack: pageView with all pages - slides, back and next button
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  static final NavigationModel navigationModel = new NavigationModel();

  CameraSlide cameraSlide = new CameraSlide();
  GallerySlide gallerySlide = new GallerySlide();
  LocationSlide locationSlide = new LocationSlide();
  QuantitySlide quantitySlide = new QuantitySlide();
  WoodSlide woodSlide = new WoodSlide();
  ContactSlide contactSlide = new ContactSlide();
  EndSlide endSlide = new EndSlide();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NavigationModel>(
      model: navigationModel,
      child: WillPopScope(
        //connect back button on android to navigation model
        onWillPop: () async {
          if (navigationModel.page == 0) {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return exitDialog(context);
              },
            );
          } else if (navigationModel.page == 6) {
            return new Future(() => false);
          } else {
            navigationModel.goBack(context);
          }
        },
        child: GestureDetector(
          //dismiss keyboard on tap outside the input field
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: navigationModel.navigationCtrl,
                    children: <Widget>[
                      cameraSlide,
                      gallerySlide,
                      Container(
                        margin: EdgeInsets.only(bottom: 80),
                        child: locationSlide,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: quantitySlide,
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 40),
                          child: woodSlide,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 90),
                        child: contactSlide,
                      ),
                      endSlide,
                    ],
                  ),
                  Positioned(
                    child: MLogo(),
                    bottom: 4.0,
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: MyBackButton(
                      fun: () => navigationModel.goBack(context),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    child: ScopedModelDescendant<NavigationModel>(
                      builder: (context, child, model) {
                        if (model.showBtn) {
                          return NextBtn(
                            text: navigationModel.nextText,
                            fun: () => navigationModel.next(context),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
