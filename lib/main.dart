import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:patienttracking/commonScreens/splashscreen.dart';
import 'package:flutter/services.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  // await FlutterConfig.loadEnvVariables();
  // await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.lightBlueAccent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patient Tracking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
