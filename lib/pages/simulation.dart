import 'dart:convert';
import 'dart:math';

import 'package:ant_farm/themes/themes.dart';
import 'package:flutter/material.dart';
import '../processing/consts.dart';

const String testJson = """{
    "isValid": true,
    "gridSpecs": [
        [
          [false, true, false, false],
          [false, true, false, false]
        ],
        [
          [false, false, true, true],
          [true, false, false, true]
        ]
    ]
}""";
//values on a per-minute basis
const String testSimJson = """{
    "isValid": true,
    "foodSpawnRate": 10,
    "antSpawnRate": 20,
    "antSpawnCeiling": 100,
    "foodToAntRatio": 0.23,
    "starvationPeriod": 40
}""";

class Farm extends StatelessWidget{
  final Controller controler = new Controller();
  Farm({Key key}) : super(key: key);

  Widget build(BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm: Farming",
          style: AppThemes.appbarText()
        ),
        backgroundColor: Colors.black,
      )
    );
  }
}

class Controller{
  SimModel model = new SimModel();
  
  Controller(){
    this.model.assembleModel(testSimJson, testJson);
    this.model.iterate();
  }

  void startSim(){

  }

  void stopSim(){

  }

}

class Renderer{
  Canvas canvas;
  Renderer(this.canvas);


}

class SimModel{
  int foodSpawnRate;
  int lastFoodSpawnEventAge = 0;

  int antSpawnRate;
  int lastAntSpawnEventAge = 0;

  int starvationPeriod;
  int antSpawnCeiling;
  double foodToAntRatio;
  final double iterationPeriod = 0.85;
  
  Map map;
  List<Ant> ants = new List();
  List<Feeding> feedings = new List();


  void assembleModel(String simJson, String mapJson){
    this.map = new Map(testJson);
    var decodedJson = json.decode(simJson);
    if(decodedJson["isValid"]){
      this.foodSpawnRate = this.convertPerMinuteToNumIterations(decodedJson["foodSpawnRate"]);
      this.antSpawnRate = this.convertPerMinuteToNumIterations(decodedJson["antSpawnRate"]);
      this.antSpawnCeiling = decodedJson["antSpawnCeiling"];
      this.foodToAntRatio = decodedJson["foodToAntRatio"];
      this.starvationPeriod = decodedJson["starvationPeriod"];
    }
    else {
      throw("Invalid simulation loaded");
    }

    this.spawnNewAnt(true);
  }
  
  bool iterate(){
    this.loopAnts();
    this.spawnNewAnt(false);
    this.spawnNewFood();
    return this.processRatio();
  }

  void loopAnts(){
    for(Ant ant in this.ants){
      this.moveAnt(ant);
      this.feedAnt(ant);
      this.starveAnt(ant);
    }
  }

  void moveAnt(Ant ant){
    var potentialDirections = this.map.getValidDirections(ant.posX, ant.posY);
  }

  void feedAnt(Ant ant){

  }

  void starveAnt(Ant ant){

  }

  void spawnNewAnt(bool initial){
    if (this.antSpawnRate <= this.lastAntSpawnEventAge || initial){
      Random random = new Random();
      var spawnX = random.nextInt(this.map.cells.length);
      var spawnY = random.nextInt(this.map.cells.length);
      var potentialDirections = this.map.getValidDirections(spawnX, spawnY);
      var newDirectionIndex = random.nextInt(potentialDirections.length);
      var newDirection = potentialDirections[newDirectionIndex];
      Ant ant = new Ant(spawnX, spawnY, newDirection);
      this.ants.add(ant);
    }
  }

  void spawnNewFood(){

  }

  bool processRatio(){
    return this.feedings.length / this.ants.length < this.foodToAntRatio;
  }

  int convertPerMinuteToNumIterations(int eventsPerMinute){
    double iterationsPerMinute = 60 / this.iterationPeriod;
    double iterationsPerEvent = iterationsPerMinute / eventsPerMinute;
    return iterationsPerEvent.round();
  }

}

class Map{
  List<List> cells = new List();

  Map(String mapJson){
    var decodedJson = json.decode(mapJson);
    if(decodedJson['isValid']){
      var gridData = decodedJson['gridSpecs'];
      for (int x = 0; x < gridData.length; x++){
        var rowData = gridData[x];
        List<GridCell> row = [];
        for (int y = 0; y < rowData.length; y++){
          row.add(new GridCell(rowData[y]));
        }
        this.cells.add(row);
      }
    }
    else {
      throw("Invalid map loaded");
    }
  }

  List getValidDirections(int x, int y){
    var validDirections = [];
    for(int i = 0; i < 4; i++){
      if(this.cells[x][y].openDirections[i]){
        validDirections.add(i);
      }
    }

    return validDirections;
  }

  void setFood(int x, int y, bool hasFood){
    this.cells[x][y].hasFood = hasFood;
  }
}

class Ant{
  int posX;
  int posY;
  int turnsSinceLastFood = 0;
  int currentDirection;
  Ant(this.posX, this.posY, this.currentDirection);
}

class Feeding{
  int age;
}

class GridCell{
  bool hasFood = false;
  List openDirections;
  GridCell(this.openDirections);
}