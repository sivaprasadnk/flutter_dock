import 'package:flutter/material.dart';
import 'package:flutter_dock/dock.dart';
import 'package:flutter_dock/icons_list.dart';

/// Entrypoint of the application.
void main() {
  runApp(MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: iconsList,
          ),
        ),
      ),
    );
  }
}
