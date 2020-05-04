import 'package:ant_farm/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:ant_farm/processing/common_classes.dart';

class SimulationConfig extends StatefulWidget{
  final Controller controller = new Controller();
  SimulationConfig({Key key}) : super(key:key);

  @override
  _SimulationConfigState createState() => new _SimulationConfigState(this.controller, key);
}

class _SimulationConfigState extends State<SimulationConfig>{
  Key key;
  int displayedContent;
  Controller controller;
  static const SELECT_SIMULATION = 0;
  static const EDIT_SIMULATION = 1;

  _SimulationConfigState(this.controller, this.key) : super(){
    this.controller.routeToEditSimulation = this.routeToEditSimulation;
    this.controller.routeToSelectSimulation = this.routeToSelectSimulation;
  }

  Widget selectBody(){
    if (this.displayedContent == _SimulationConfigState.SELECT_SIMULATION){
      return new SelectSimulation(this.controller, key: this.key);
    }
    else if (this.displayedContent == _SimulationConfigState.EDIT_SIMULATION){
      return new EditSimulation(this.controller, key: this.key);
    }
    else {
      return new SelectSimulation(this.controller, key: this.key);
    }
  }

  void routeToSelectSimulation(){
    this.setState((){
      this.displayedContent = _SimulationConfigState.SELECT_SIMULATION;
    });
  }

  void routeToEditSimulation(){
    this.setState((){
      this.displayedContent = _SimulationConfigState.EDIT_SIMULATION;
    });
  }

  Widget build(BuildContext build){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ant Farm: Simulation Config",
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
                "Select Simulation",
                style: AppThemes.listTileText()  
              ),
              onTap: () => this.setState(() {
                this.displayedContent = _SimulationConfigState.SELECT_SIMULATION;
                Navigator.pop(build);
              }),
            ),
            ListTile(
              title: Text(
                "Edit Simulation",
                style: AppThemes.listTileText()  
              ),
              onTap: () => this.setState(() {
                this.displayedContent = _SimulationConfigState.EDIT_SIMULATION;
                Navigator.pop(build);
              }),
            )
          ],
        )
      ),
    );
  }
}

class SelectSimulation extends StatefulWidget{
  final Controller controller;
  SelectSimulation(this.controller, {Key key}) : super(key: key);

  @override
  _SelectSimulationState createState() => new _SelectSimulationState(this.controller);
}

class _SelectSimulationState extends State<SelectSimulation>{
  Controller controller;
  TextEditingController newSimulationNameController = new TextEditingController();
  BooleanRefWrapper showDialogErrorText = new BooleanRefWrapper(false);
  List<String> simulations;
  _SelectSimulationState(this.controller){
    this.simulations = this.controller.getSimulationList();
  }

  Widget build(BuildContext build){
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: RaisedButton(
            child: Text(
              "New Simulation",
              style: AppThemes.buttonText(),
            ),
            onPressed: () {
              showDialog(
                context: build,
                builder: (BuildContext build){
                  return StatefulBuilder(
                    builder: (context, setState){
                      return GetTextDialogue.makeDialog(
                        prompt: "What do you want to name your simulation?",
                        errorText: "Invalid name entered, alpha numeric only.",
                        validateText: Simulation.validateName,
                        showErrorText: this.showDialogErrorText,
                        textValueController: this.newSimulationNameController,
                        setState: setState,
                        submit: (String text){
                          Navigator.of(build, rootNavigator: true).pop();
                          this.controller.newSimultion(text);
                          this.controller.routeToEditSimulation();
                        }
                      );
                    }
                  );
                }
              );
            }
          )
        )
      ],
    );
  }
}

class EditSimulation extends StatelessWidget{
  final Controller controller;
  EditSimulation(this.controller, {Key key}) : super(key: key);

  Widget build(BuildContext build){
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30
          ),
          SimulationConfigField(
            color: Colors.blue,
            title: "Food Spawns Per Minute",
            errorMsg: "Invalid Spawn Rate.",
            hintText: "10",
          ),
          SimulationConfigField(
            color: Colors.yellow,
            title: "Ant Spawns Per Minute",
            errorMsg: "Invalid Spawn Rate.",
            hintText: "10",
          ),
          SimulationConfigField(
            color: Colors.green,
            title: "Ant Spawn Ceiling",
            errorMsg: "Ceiling must be between 1 and 64.",
            hintText: "15",
          ),
          SimulationConfigField(
            color: Colors.orange,
            title: "Food To Ant Ratio",
            errorMsg: "Invalid ratio",
            hintText: "0.1",
          ),
          SimulationConfigField(
            color: Colors.purple,
            title: "Starvation Period",
            errorMsg: "Invalid starvation period",
            hintText: "40"
          ),
          SimulationConfigField(
            color: Colors.red,
            title: "Food Durability",
            errorMsg: "Invalid food durability",
            hintText: "40",
          ),
          Container(
            margin: EdgeInsets.all(30),
            child: SizedBox(
              height: 50,
              child: RaisedButton(
                onPressed: (){},
                child: Text(
                  "Validate and Save",
                  style: AppThemes.buttonText()
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

class SimulationConfigField extends StatelessWidget{
  final TextEditingController textController = new TextEditingController();
  final Color color;
  final String title;
  final String errorMsg;
  final String hintText;
  final bool showErrorMessage = false;
  final bool valueSet = false;
  SimulationConfigField({Key key, this.title, this.errorMsg, this.hintText, this.color}) : super(key: key);

  Widget build(BuildContext build){

    return StatefulBuilder(
      builder: (BuildContext build, StateSetter setState){
        return Container(
          margin: EdgeInsets.only(bottom: 5),
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            color: this.color
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10
              ),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: this.textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: this.hintText
                  ),
                )
              ),
              SizedBox(
                width: 10
              ),
              Expanded(
                child: Text(
                  this.title,
                  style: AppThemes.bodyText()
                )
              )
            ],
          )
        );
      }
    );
  }
}

class Controller{
  Simulation simulation;
  List<String> simulations;
  Function routeToSelectSimulation;
  Function routeToEditSimulation;

  void newSimultion(String name){
    this.simulation = new Simulation.fromName(name);
  }

  void loadSimulation(String name){

  }

  void saveCurrentSimulation(){

  }

  List<String> getSimulationList(){
    if (this.simulations != null){
      return this.simulations;
    }
    else {
      //read in simulation names
      return [];
    }
  }
}

class Simulation{
  bool isValid = true;
  String name;

  int foodSpawnRate;
  int antSpawnRate;
  int antSpawnCeiling;
  double foodToAntRatio;
  int starvationPeriod;
  int foodDurability;

  Simulation.fromName(this.name);

  void validateSimulation(){

  }

  static bool validateName(String text){
    RegExp exp = new RegExp(r"^[a-zA-Z0-9]+$");
    return exp.hasMatch(text);
  }
}