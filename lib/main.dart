import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fl;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return fl.FluentApp(
      debugShowCheckedModeBanner: false,
      theme: fl.FluentThemeData(
        accentColor: fl.Colors.blue,
        brightness: fl.Brightness.dark,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
