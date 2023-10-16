import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class USerprofile extends StatefulWidget {
  const USerprofile({super.key});

  @override
  State<USerprofile> createState() => _USerprofileState();
}

class _USerprofileState extends State<USerprofile> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Users');

  late dynamic fullName;
  late dynamic phoneNumber;
  late dynamic email;
  late dynamic disease;
  late dynamic address;
  late dynamic province;
  late dynamic city;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User userID;

  @override
  void initState() {
    super.initState();
    userID = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    // instanciate the Firebase DB
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: ref.child(userID.uid).onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
              if (map['UserName'] == null) {
                map['UserName'] = 'No Name Set';
              }
              if (map['Phone'] == null) {
                map['Phone'] = 'No Phone';
              }
              if (map['email'] == null) {
                map['email'] = 'Email Not Set Please Update';
              }
              if (map['Disease'] == null) {
                map['Disease'] = 'Disease Not Updated Please Update';
              }
              if (map['Address'] == null) {
                map['Address'] = 'No Address';
              }
              if (map['Province'] == null) {
                map['Province'] = 'No Province';
              }
              if (map['City'] == null) {
                map['City'] = 'No City';
              }
              fullName = map['UserName'];
              phoneNumber = map['Phone'];
              email = map['email'];
              disease = map['Disease'];
              address = map['Address'];
              province = map['Province'];
              city = map['City'];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Full Name'),
                      subtitle: Text(fullName),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Phone Number'),
                      subtitle: Text(phoneNumber),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.local_hospital),
                      title: const Text('Disease'),
                      subtitle: Text(disease),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Address'),
                      subtitle: Text(address),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text('City'),
                      subtitle: Text(city),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Province'),
                      subtitle: Text(province),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
              ));
            }
          },
        ),
      ),
    );
  }
}



// =============================================================================
// =============================================================================
// =============================================================================

// CODE tO BE USED laTER FOR SMS SENDING
// For testing SMS Feature of the Application.
// class SMSSending extends StatefulWidget {
//   @override
//   _SMSSendingState createState() => _SMSSendingState();
// }

// class _SMSSendingState extends State<SMSSending> {
//   _getPermission() async => await [
//         Permission.sms,
//       ].request();

//   Future<bool> _isPermissionGranted() async =>
//       await Permission.sms.status.isGranted;

//   _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
//     var result = await BackgroundSms.sendMessage(
//         phoneNumber: phoneNumber, message: message, simSlot: simSlot);
//     if (result == SmsStatus.sent) {
//       print("Sent");
//     } else {
//       print("Failed");
//     }
//   }

//   Future<bool?> get _supportCustomSim async =>
//       await BackgroundSms.isSupportCustomSim;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Send Sms'),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.send),
//           onPressed: () async {
//             if (await _isPermissionGranted()) {
//               if ((await _supportCustomSim)!) {
//                 _sendMessage("0777846270", "Hello world", simSlot: 1);
//               } else
//                 _sendMessage("0966851088", "Hello");
//             } else
//               _getPermission();
//           },
//         ),
//       ),
//     );
//   }
// }
