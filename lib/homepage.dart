import 'package:flutter/material.dart';
import 'themes/themes.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  Widget build (BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm",
          style: AppThemes.appbarText(),
        ),
        backgroundColor: Colors.black,
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.pushNamed(build, 'farm'),
              child: Text(
                "Git Farmin'",
                style: AppThemes.buttonText()
              ),
            ),
          ]
        )
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "Simulation Builder",
                style: AppThemes.listTileText()  
              ),
              onTap: () {
                Navigator.pop(build);
                return Navigator.pushNamed(build, 'configSim');
              },
            ),
            ListTile(
              title: Text(
                "Instructions",
                style: AppThemes.listTileText()  
              ),
              onTap: (){
                Navigator.pop(build);
                return Navigator.pushNamed(build, 'tutorial');
              }
            )
          ]
        )
      ),
    );
  }
}
