import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes{

  static TextStyle appbarText(){
    return GoogleFonts.anton();
  }

  static TextStyle buttonText(){
    return GoogleFonts.anton(
      color: Colors.white
    );
  }

  static TextStyle listTileText(){
    return GoogleFonts.anton();
  }

  static TextStyle bodyText(){
    return GoogleFonts.anton();
  }
}