import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:zoom_widget/zoom_widget.dart';
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
//food durability = how many seconds food should last for
const String testSimJson = """{
    "isValid": true,
    "foodSpawnRate": 10,
    "antSpawnRate": 20,
    "antSpawnCeiling": 100,
    "foodToAntRatio": 0.23,
    "starvationPeriod": 40,
    "foodDurability": 40
}""";

class Farm extends StatefulWidget{
  final Controller controller = new Controller();
  Farm({Key key}) : super(key: key);

  @override
  _FarmState createState() => new _FarmState(this.controller, key);
}

class _FarmState extends State<Farm>{
  final Controller controller;
  final Key key;

  static const selectSimulation = 0;
  static const viewSimulationStats = 1;
  static const viewFarm = 2;
  
  int displayedContent = _FarmState.viewFarm;
  _FarmState(this.controller, this.key);

  selectBody(){
    if(this.displayedContent == _FarmState.selectSimulation){
      return SelectSimulation(this.controller, key: key);
    }
    else if(this.displayedContent == _FarmState.viewSimulationStats){
      return ViewSimulationStats(this.controller, key: key);
    }
    else if(this.displayedContent == _FarmState.viewFarm){
      return ViewFarm(this.controller, key: key);
    }
  }

  Widget build(BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm: Farming",
          style: AppThemes.appbarText()
        ),
        backgroundColor: Colors.black,
      ),
      body: this.selectBody(),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "View Farm",
                style: AppThemes.listTileText()
              ),
              onTap: () => setState(() {
                this.displayedContent = _FarmState.viewFarm;
                Navigator.pop(build);
              }),
              onLongPress: (){this.controller.redraw();},
            ),
            ListTile(
              title: Text(
                "Simulation Stats",
                style: AppThemes.listTileText()
              ),
              onTap: () => setState(() {
                this.displayedContent = _FarmState.viewSimulationStats;
                Navigator.pop(build);
              }),
            ),
            ListTile(
              title: Text(
                "Select Simulation",
                style: AppThemes.listTileText()
              ),
              onTap: () => setState(() {
                this.displayedContent = _FarmState.selectSimulation;
                Navigator.pop(build);
              }),
            )
          ]
        )
      ),
    );
  }
}

class SelectSimulation extends StatelessWidget{
  SelectSimulation(Controller controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext build){
    return Center(
      child: Text("Select Sim Here")
    );
  }
}

class ViewSimulationStats extends StatelessWidget{
  ViewSimulationStats(Controller controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext build){
    return Center(
      child: Text("View Stats Here")
    );
  }
}

class ViewFarm extends StatelessWidget{
  final Controller controller;
  ViewFarm(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext build){
    Listenable repaint = new RepaintListenable();
    Renderer renderer = new Renderer(repaint, this.controller.getModelState);
    this.controller.setRenderer(renderer, repaint);

    return Zoom(
      width: 1800,
      height: 1800,
      initZoom: 0.0,
      child: FittedBox(
        child:SizedBox(
          width: 1800,
          height: 1800,
          child: CustomPaint(
            painter: renderer
          )
        )
      )
    );
  }
}

class Renderer extends CustomPainter{
  Function getModelState;

  Renderer(RepaintListenable repaint, this.getModelState) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size){
    List modelRefs = getModelState();
    Paint paint = new Paint()
    ..color = Colors.blue
    ..isAntiAlias = true;
    canvas.drawCircle(Offset(100.0, 100.0), 50.0, paint);
  }

  @override
  bool shouldRepaint(Renderer oldDelegate) => false;

  void initializeGameBoard(List<List> grid){
    
  }

  void drawStage(LinkedList<Ant> ants, List<List> grid){

  }
}

class RepaintListenable extends ChangeNotifier{
  void startRedrawEvent(){
    notifyListeners();
  }
}

class Controller{
  SimModel model = new SimModel();
  Renderer renderer;
  RepaintListenable repaint;
  double radius = 50.0;

  Controller(){
    this.renderer = null;
    this.repaint = null;
    this.model.assembleModel(testSimJson, testJson);
  }

  void startSim(){

  }

  void stopSim(){

  }

  void advanceSimulation(){

  }

  void redraw(){
    this.repaint.startRedrawEvent();
  }

  void setRenderer(Renderer renderer, RepaintListenable repaint){
    this.renderer = renderer;
    this.repaint = repaint;
    this.renderer.initializeGameBoard(this.model.map.cells);
  }

  List getModelState(){
    return [this.model.ants, this.model.map.cells];
  }

  void setModel(SimModel model){
    this.model = model;
  }

}

class SimModel{
  int foodSpawnRate;
  int lastFoodSpawnEventAge = 0;

  int antSpawnRate;
  int lastAntSpawnEventAge = 0;

  int starvationPeriod;
  int antSpawnCeiling;
  int foodDurability;
  double foodToAntRatio;
  int width;
  int height;
  final double iterationPeriod = 0.85;
  
  Map map;
  LinkedList<Ant> ants = new LinkedList();
  LinkedList<Feeding> feedings = new LinkedList();


  void assembleModel(String simJson, String mapJson){
    this.map = new Map(testJson);
    var decodedJson = json.decode(simJson);
    if(decodedJson["isValid"]){
      this.foodSpawnRate = this.convertPerMinuteToNumIterations(decodedJson["foodSpawnRate"]);
      this.antSpawnRate = this.convertPerMinuteToNumIterations(decodedJson["antSpawnRate"]);
      this.antSpawnCeiling = decodedJson["antSpawnCeiling"];
      this.foodToAntRatio = decodedJson["foodToAntRatio"];
      this.starvationPeriod = decodedJson["starvationPeriod"];
      this.foodDurability = this.convertSecsToIterations(decodedJson["foodDurability"]);
      this.width = this.map.cells.length;
      this.height = this.map.cells[0].length;
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
    this.removeOldFeedings();
    return this.processRatio();
  }

  void loopAnts(){
    for(Ant ant in this.ants){
      ant.iterationsSinceLastFood++;
      this.moveAnt(ant);
      this.feedAnt(ant);
      this.starveAnt(ant);
    }
  }

  void moveAnt(Ant ant){
    Random random = new Random();
    var potentialDirections = this.map.getValidDirections(ant.posX, ant.posY);

    if (!potentialDirections.contains(ant.currentDirection)){
      var newDirectionIndex = random.nextInt(potentialDirections.length);
      var newDirection = potentialDirections[newDirectionIndex];
      ant.currentDirection = newDirection;
    }

    if(ant.currentDirection == TOP){
      ant.posY--;
    }
    else if(ant.currentDirection == RIGHT){
      ant.posX++;
    }
    else if(ant.currentDirection == BOTTOM){
      ant.posY++;
    }
    else if(ant.currentDirection == LEFT){
      ant.posX--;
    }
  }

  void feedAnt(Ant ant){
    int numFoods = this.map.eatFood(ant.posX, ant.posY);
    if(numFoods > 0){
      ant.iterationsSinceLastFood = 0;

      for(int i = 0; i < numFoods; i++){
        Feeding feeding = new Feeding();
        this.feedings.add(feeding);
      }
    }
  }

  void starveAnt(Ant ant){
    if(ant.iterationsSinceLastFood > this.starvationPeriod){
      ant.unlink();
    }
    else {
      ant.iterationsSinceLastFood++;
    }
  }

  void removeOldFeedings(){
    for(Feeding feeding in this.feedings){
      if(this.foodDurability > feeding.age){
        feeding.age++;
      } else {
        feeding.unlink();
      }
    }
  }

  void spawnNewAnt(bool initial){
    if ((this.antSpawnRate <= this.lastAntSpawnEventAge && this.ants.length <= this.antSpawnCeiling) || initial){
      this.lastAntSpawnEventAge = 0;
      Random random = new Random();
      var spawnX = random.nextInt(this.width);
      var spawnY = random.nextInt(this.height);
      var potentialDirections = this.map.getValidDirections(spawnX, spawnY);
      var newDirectionIndex = random.nextInt(potentialDirections.length);
      var newDirection = potentialDirections[newDirectionIndex];
      Ant ant = new Ant(spawnX, spawnY, newDirection);
      this.ants.add(ant);

      Feeding feeding = new Feeding();
      this.feedings.add(feeding);
    }
    else {
      this.lastAntSpawnEventAge++;
    }
  }

  void spawnNewFood(){
    if(this.foodSpawnRate <= this.lastFoodSpawnEventAge){
      this.lastFoodSpawnEventAge = 0;
      Random random = new Random();
      var spawnX = random.nextInt(this.width);
      var spawnY = random.nextInt(this.height);
      this.map.addFood(spawnX, spawnY);
    } else {
      this.lastFoodSpawnEventAge++;
    }
  }

  bool processRatio(){
    return this.feedings.length / this.ants.length > this.foodToAntRatio;
  }

  int convertPerMinuteToNumIterations(int eventsPerMinute){
    double iterationsPerMinute = 60 / this.iterationPeriod;
    double iterationsPerEvent = iterationsPerMinute / eventsPerMinute;
    return iterationsPerEvent.round();
  }

  int convertSecsToIterations(int secondsPerEvent){
    return (secondsPerEvent / this.iterationPeriod).round();
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

  void addFood(int x, int y){
    this.cells[x][y].numFood++;
  }

  int eatFood(int x, int y){
    int numFood = this.cells[x][y].numFood;
    this.cells[x][y].numFood = 0;
    return numFood;

  }
}

class Ant extends LinkedListEntry<Ant>{
  int posX;
  int posY;
  int iterationsSinceLastFood = 0;
  int currentDirection;
  Ant(this.posX, this.posY, this.currentDirection);
}

class Feeding extends LinkedListEntry<Feeding>{
  int age = 0;
}

class GridCell{
  int numFood = 0;
  List openDirections;
  GridCell(this.openDirections);
}