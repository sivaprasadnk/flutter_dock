import 'package:flutter/material.dart';
import 'package:flutter_dock/dock.dart';
import 'package:flutter_dock/icons_list.dart';

/// The entry point of the application.
///
/// This function initializes and runs the Flutter app by calling [runApp].
void main() {
  runApp(MyApp());
}

/// A [StatelessWidget] that builds the root of the application.
///
/// The [MyApp] widget initializes the [MaterialApp] with a custom
/// home screen and other configuration settings.
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner.
      home: Scaffold(
        /// The main content of the application, which includes a dock.
        ///
        /// The dock displays a list of icons provided by [iconsList].
        body: Center(
          child: Dock(
            /// The [Dock] widget is used to display a customizable dock layout.
            ///
            /// [items] takes a list of icons defined in the [iconsList].
            items: iconsList,
          ),
        ),
      ),
    );
  }
}
