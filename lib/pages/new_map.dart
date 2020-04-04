import 'package:flutter/material.dart';
import '../themes/themes.dart';

class NewMap extends StatefulWidget{
  NewMap({Key key}) : super(key: key);

  @override
  _NewMapState createState() => _NewMapState(key);
}

class _NewMapState extends State<NewMap>{
  static const int jsonEditor = 0;
  static const int guiMapCreator = 1;
  static const int mapUpload = 2;
  var key;
  _NewMapState(this.key);
  int displayedContent = _NewMapState.jsonEditor;
  String currentMap;

  selectBody(){
    if(this.displayedContent == _NewMapState.jsonEditor){
      return JSONEditor(key, currentMap);
    }
    else if (this.displayedContent == _NewMapState.guiMapCreator){
      return GUIMapMaker(key, currentMap);
    }
    else if (this.displayedContent == _NewMapState.mapUpload){
      return MapUpload(key, currentMap);
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
                this.displayedContent = _NewMapState.jsonEditor;
                Navigator.pop(build);
              }),
              title: Text(
                "JSON Editor",
                style: AppThemes.listTileText(),
              ),
            ),
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
                "Map File Upload",
                style: AppThemes.listTileText()
              ),
            )
          ],
        ),
      ),
      body: this.selectBody()
    );
  }
}

class JSONEditor extends StatelessWidget{
  JSONEditor(Key key, String map) : super(key: key);

  Widget build(BuildContext build){
    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        Text("Enter JSON Here"),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2
            )
          ),
          margin: EdgeInsets.only(
            left: 10,
            right: 10
          ),
          child: TextField(
            maxLines: 15
          )
        )
      ],
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

class MapUpload extends StatelessWidget{
  MapUpload(Key key, String map) : super(key: key);

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