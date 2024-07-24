import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:receiver/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  if (Platform.isWindows) {
    // await Window.hideWindowControls();
    // Window.makeTitlebarTransparent();
    await Window.setEffect(
      effect: WindowEffect.aero,
      color: Colors.black.withOpacity(0.9),
      dark: true,
    );

    doWhenWindowReady(() {
      appWindow
        ..minSize = Size(640, 360)
        ..size = Size(720, 540)
        ..alignment = Alignment.center
        ..title = ""
        ..show();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
