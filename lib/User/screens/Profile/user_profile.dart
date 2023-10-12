import 'package:flutter/material.dart';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// class USerprofile extends StatefulWidget {
//   const USerprofile({super.key});

//   @override
//   State<USerprofile> createState() => _USerprofileState();
// }

// class _USerprofileState extends State<USerprofile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: Colors.lightBlueAccent,
//         title: const Center(
//             child: Text(
//           'Profile',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         )),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Padding(
//                 padding: EdgeInsets.only(
//               top: 40,
//             )),
//             SMSSending(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// For testing SMS Feature of the Application.
class SMSSending extends StatefulWidget {
  @override
  _SMSSendingState createState() => _SMSSendingState();
}

class _SMSSendingState extends State<SMSSending> {
  _getPermission() async => await [
        Permission.sms,
      ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }

  Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Send Sms'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () async {
            if (await _isPermissionGranted()) {
              if ((await _supportCustomSim)!) {
                _sendMessage("0777846270", "Hello world", simSlot: 1);
              } else
                _sendMessage("0966851088", "Hello");
            } else
              _getPermission();
          },
        ),
      ),
    );
  }
}
