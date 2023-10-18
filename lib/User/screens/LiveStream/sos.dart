import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class SOS extends StatefulWidget {
  const SOS({super.key});

  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  final lveIdController = TextEditingController();
  final String userId = Random().nextInt(900000 + 10000).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Your User ID: $userId",
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: lveIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Joing OR start Live Meeting by Inputing ID',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ZegoLivePage(
                  //       userId: userId,
                  //       roomId: lveIdController.text,
                  //     ),
                  //   ),
                  // );
                },
                child: Text("Join Live Meeting"),
              ),
            ],
          )),
    );
  }
}
