import 'package:fitness_gurus_challenger/services/navigation_service.dart';
import 'package:flutter/material.dart';

class MyMaterialApp extends StatelessWidget {
  final Brightness brightness;
  static final routes = NavigationService().routes;

  MyMaterialApp({this.brightness});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Gurus Challenger',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(primary: Color(0xff335078))),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff335078)),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all<Color>(Colors.green),
          fillColor: MaterialStateProperty.all<Color>(Colors.white),
        ),

        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: brightness,
      ),
      routes: routes,
    );
  }
}
