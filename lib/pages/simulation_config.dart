import 'package:ant_farm/themes/themes.dart';
import 'package:flutter/material.dart';

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
        RaisedButton(
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
      ],
    );
  }
}

class EditSimulation extends StatefulWidget{
  final Controller controller;
  EditSimulation(this.controller, {Key key}) : super(key: key);

  @override
  _EditSimulationState createState() => new _EditSimulationState();
}

class _EditSimulationState extends State<EditSimulation>{

  Widget build(BuildContext build){
    return Text("edit sim");
  }
}

class GetTextDialogue {
  static Dialog makeDialog({
    String prompt, 
    String buttonText = "Submit", 
    Function submit, 
    Function validateText, 
    Function setState, 
    BooleanRefWrapper showErrorText, 
    String errorText,
    TextEditingController textValueController}
  ){
    if(!showErrorText.value){
      errorText = "";
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Container(
        height: 200,
        width: 320.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  prompt,
                  style: AppThemes.bodyText()
                )
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: textValueController,
              ),
              Text(
                errorText,
                style: AppThemes.errorText()
              ),
              SizedBox(
                width: 320.0,
                child: RaisedButton(
                  onPressed: () {
                    if (validateText(textValueController.text)){
                      showErrorText.value = false;
                      submit(textValueController.text);
                    }
                    else {
                      setState((){
                        showErrorText.value = true;
                      });
                    }
                  },
                  child: Text(
                    buttonText,
                    style: AppThemes.buttonText(),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class BooleanRefWrapper{
  bool value;
  BooleanRefWrapper(this.value);
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

  int foodSpawnRate = 10;
  int antSpawnRate = 10;
  int antSpawnCeiling = 8;
  double foodToAntRatio = 0.01;
  int starvationPeriod = 40;
  int foodDurability = 50;

  Simulation.fromName(this.name);

  void validateSimulation(){

  }

  static bool validateName(String text){
    RegExp exp = new RegExp(r"^[a-zA-Z0-9]+$");
    return exp.hasMatch(text);
  }
}