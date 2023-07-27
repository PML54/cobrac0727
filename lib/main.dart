import 'package:cobrac/managerpml.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ou
// void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CobracWeb',
      home: ManagerPML(),
    );
  }
}
