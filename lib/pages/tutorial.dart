import 'package:ant_farm/themes/themes.dart';
import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget{
  Tutorial({Key key}) : super(key: key);

  Widget build(BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm: Tutorial",
          style: AppThemes.appbarText()
        ),
        backgroundColor: Colors.black,
      )
    );
  }
}