import 'package:flutter/material.dart';
import 'package:ant_farm/themes/themes.dart';

class MapRenderer{
  static List drawDirections = [
    [[0,0],[1,0]],//top
    [[1,0],[1,1]],//right
    [[1,1],[0,1]],//bottom
    [[0,1],[0,0]]//left
  ];

  static List<List> getOffsetsFromGrid(List grid, double wallUnitLength){
    List<List> wallPoints = [];

    for (int x = 0; x < grid.length; x++){
      List column = grid[x];
      for (int y =0; y < column.length; y++){
        List cell = column[y].openDirections;
        wallPoints += MapRenderer.getCellOffsets(x, y, cell, wallUnitLength);
      }
    }

    return wallPoints;
    // TODO: filter wallpoints list to remove duplicates
  }

  static List<List> getCellOffsets(int x, int y, List dirs, double wallUnitLength){
    double originalX = x * wallUnitLength;
    double originalY = y * wallUnitLength;
    List<List> walls = [];

    for (int i = 0; i < 4; i++){
      if(!dirs[i]){
        double canvasStartX = MapRenderer.drawDirections[i][0][0] * wallUnitLength + originalX;
        double canvasStartY = MapRenderer.drawDirections[i][0][1] * wallUnitLength + originalY;
        double canvasEndX = MapRenderer.drawDirections[i][1][0] * wallUnitLength + originalX;
        double canvasEndY = MapRenderer.drawDirections[i][1][1] * wallUnitLength + originalY;

        Offset start = Offset(canvasStartX, canvasStartY);
        Offset end = Offset(canvasEndX, canvasEndY);

        walls.add([start, end]);
      }
    }

    return walls;
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