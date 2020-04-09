import 'package:ant_farm/themes/themes.dart';
import 'package:flutter/material.dart';

class SimulationConfig extends StatelessWidget{
  SimulationConfig(Key key) : super(key: key);

  Widget build(BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm: Simulation Config",
          style: AppThemes.appbarText()
        ),
        backgroundColor: Colors.black,
      )
    );
  }
}