import 'package:flutter/material.dart';

class Farm extends StatelessWidget{
  Farm(Key key) : super(key: key);

  Widget build(BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text("Ant Farm: Farming"),
        backgroundColor: Colors.black,
      )
    );
  }
}