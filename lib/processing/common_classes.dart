import 'package:flutter/material.dart';

class MapRenderer{
  static List drawDirections = [
    [[0,0],[1,0]],//top
    [[1,0],[1,1]],//right
    [[1,1],[0,1]],//bottom
    [[0,1],[0,0]]//left
  ];

  static void drawBox(int x, int y, List dirs, double wallUnitLength, Canvas canvas, Paint paint){
    double originalX = x * wallUnitLength;
    double originalY = y * wallUnitLength;

    for (int i = 0; i < 4; i++){
      if(!dirs[i]){
        double canvasStartX = MapRenderer.drawDirections[i][0][0] * wallUnitLength + originalX;
        double canvasStartY = MapRenderer.drawDirections[i][0][1] * wallUnitLength + originalY;
        double canvasEndX = MapRenderer.drawDirections[i][1][0] * wallUnitLength + originalX;
        double canvasEndY = MapRenderer.drawDirections[i][1][1] * wallUnitLength + originalY;

        Offset start = Offset(canvasStartX, canvasStartY);
        Offset end = Offset(canvasEndX, canvasEndY);

        canvas.drawLine(start, end, paint);
      }
    }
  }
}