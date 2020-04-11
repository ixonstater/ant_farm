import 'package:flutter/material.dart';
import '../themes/themes.dart';

class NewMap extends StatefulWidget{
  NewMap({Key key}) : super(key: key);

  @override
  _NewMapState createState() => _NewMapState(key);
}

class _NewMapState extends State<NewMap>{
  static const int guiMapCreator = 0;
  static const int mapUpload = 1;
  var key;
  _NewMapState(this.key);
  int displayedContent = _NewMapState.guiMapCreator;
  String currentMap = "{}";

  selectBody(){
    if (this.displayedContent == _NewMapState.guiMapCreator){
      return GUIMapMaker(key, currentMap);
    }
    else if (this.displayedContent == _NewMapState.mapUpload){
      return SelectMap(key, currentMap);
    }
  }

  Widget build(BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm: Map Maker",
          style: AppThemes.appbarText()
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              onTap: () => setState(() {
                this.displayedContent = _NewMapState.guiMapCreator;
                Navigator.pop(build);  
              }),
              title: Text(
                "GUI Map Creator",
                style: AppThemes.listTileText()
              ),
            ),
            ListTile(
              onTap: () => setState(() {
                this.displayedContent = _NewMapState.mapUpload;
                Navigator.pop(build);
              }),
              title: Text(
                "Change Selected Map",
                style: AppThemes.listTileText()
              ),
            )
          ],
        ),
      ),
      body: this.selectBody(),
      resizeToAvoidBottomPadding: true,
    );
  }
}

class GUIMapMaker extends StatelessWidget{
  GUIMapMaker(Key key, String map) : super(key: key);

  Widget build(BuildContext build){
    return Align(
      alignment: Alignment.center,
      child: Text(
        "Coming Soon!",
        style: AppThemes.bodyText()
      )
    );
  }
}

class SelectMap extends StatelessWidget{
  SelectMap(Key key, String map) : super(key: key);

  Widget build(BuildContext build){
    return Align(
      alignment: Alignment.center,
      child: Text(
        "Coming Soon!",
        style: AppThemes.bodyText()
      )
    );
  }
}