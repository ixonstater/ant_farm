import 'package:flutter/material.dart';
import 'homepage.dart';
import 'pages/simulation_config.dart' show SimulationConfig;
import 'pages/tutorial.dart' show Tutorial;
import 'pages/simulation.dart' show Farm;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimulationConfig(),
      // home: HomePage(),
      routes: {
        'configSim': (context) => new SimulationConfig(),
        'tutorial': (context) => new Tutorial(),
        'farm': (context) => new Farm()
      },
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.black,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.black,
        ),
      )
    );
  }
}