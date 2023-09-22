import 'package:flutter/material.dart';
class LogingScreen extends StatelessWidget {
  const LogingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),// to add padding from all sides
        child: Column(
          children: [
            SizedBox(
              height: 45.0,
            ),
            Image(
              image: AssetImage("images/logo.png"),
              width: 390.0,
              height: 250.0,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),

    );
  }
}
