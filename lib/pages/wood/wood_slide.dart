import 'package:flutter/material.dart';
import 'package:recappture2/helpers/components.dart';
import 'package:recappture2/helpers/my_colors.dart';
import 'package:recappture2/scoped_models/wood_model.dart';

class WoodSlide extends StatefulWidget {
  @override
  WoodSlideState createState() => WoodSlideState();
}

class WoodSlideState extends State<WoodSlide>
    with AutomaticKeepAliveClientMixin<WoodSlide> {
  static final WoodModel woodModel = new WoodModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MyImage(
            height: 60,
            asset: 'assets/wood.png',
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: MyText(
              text: 'Izberite vrsto lesa',
              size: 25,
              color: MyColors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 4),
            child: MyText(
              text: 'Kateri sliki je les bolj podoben?',
              size: 18,
              color: MyColors.grey,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            height: MediaQuery.of(context).size.height / 2,
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: woodModel.woodCtrl,
              scrollDirection: Axis.vertical,
              itemCount: 4,
              itemBuilder: (context, index) {
                return woodPage(index, () => woodModel.addDeciduous(context),
                    () => woodModel.addConiferous(context));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget woodPage(int index, Function funDeciduous, funConiferous) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: funDeciduous,
                  child: Image.asset(
                    'assets/listavec${index + 1}.png',
                    fit: BoxFit.contain,
                  ),
                ),
                MyText(
                  text: 'Listavec',
                  color: MyColors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: funConiferous,
                  child: Image.asset(
                    'assets/iglavec${index + 1}.png',
                    fit: BoxFit.contain,
                  ),
                ),
                MyText(
                  text: 'Iglavec',
                  color: MyColors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
