import 'dart:developer';

import 'package:flutter/material.dart';

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