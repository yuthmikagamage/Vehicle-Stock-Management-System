import 'package:flutter/material.dart';
import 'Screens/login.dart';
import 'Screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(VehicleStock());
}

class VehicleStock extends StatelessWidget {
  const VehicleStock({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
