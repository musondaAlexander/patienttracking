import 'package:flutter/material.dart';

class USerprofile extends StatefulWidget {
  const USerprofile({super.key});

  @override
  State<USerprofile> createState() => _USerprofileState();
}

class _USerprofileState extends State<USerprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Center(
            child: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}
