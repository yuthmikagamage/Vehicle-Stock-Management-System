import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:frontend/config.dart';
import 'Screens/login.dart';
import 'Screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
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
