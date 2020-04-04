import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  Widget build (BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm"
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () => print("farmin'"),
                color: Colors.black,
                child: Text(
                    "Git Farmin'",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
              )
            )
          )
        ]
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Hellow tile"),
              onTap: (){},
            )
          ]
        )
      ),
    );
  }
}
