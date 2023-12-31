import 'package:background_sms/background_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patienttracking/Features/EmergencyContacts/emergency_contact.dart';
import 'package:patienttracking/User/DangerZones/danger_zones.dart';
import 'package:patienttracking/User/controllers/authentication_controller.dart';
import 'package:patienttracking/User/screens/DashBoard/user_dashboard.dart';
import 'package:location/location.dart';
import 'package:patienttracking/User/screens/LiveStream/sos.dart';
import 'package:patienttracking/User/screens/Profile/profile_screen.dart';
import 'package:patienttracking/commonScreens/Location/share_location.dart';
import 'package:permission_handler/permission_handler.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  GoogleMapController? _controller;
  LocationData? _currentLocation;

  DatabaseReference ref = FirebaseDatabase.instance.ref('Users');
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User userID;

  @override
  void initState() {
    super.initState();
    _initLocation();
    userID = _auth.currentUser!;
  }

  void _initLocation() async {
    final location = Location();
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  handleSmsPermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      debugPrint("SMS Permission Granted");
      return true;
    } else {
      debugPrint("SMS Permission Denied");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = "";
    String disease = "";
    String title = 'BackgroundGeolocation Demo';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text(
                'User Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.grey,
              ),
              title: const Text('Profile'),
              onTap: () {
                Get.to(
                  () => const ProfileScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                );
                // Handle profile item click
              },
            ),
            GestureDetector(
              onTap: () {
                // Handle dashboard item click
                Get.to(
                  () => const UserDashboard(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.dashboard,
                  color: Colors.grey,
                ),
                title: Text('First Responders'),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_emergency,
                color: Colors.grey,
              ),
              title: const Text('Emergency contacts'),
              onTap: () {
                Get.to(
                  const ContactListScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                );
              },
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Get.to(
                  const ShareMyLocation(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
                title: Text('Share Live Location'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  const SOS(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.video_call,
                  color: Colors.grey,
                ),
                title: Text('Go Live With Video'),
              ),
            ),

            // Add more items as needed
            const Divider(),
            GestureDetector(
              onTap: () {
                // sendSMS();
                Get.to(
                  PatientScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.dangerous,
                  color: Colors.grey,
                ),
                title: Text('Danger Zones'),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.grey,
              ),
              title: const Text('Logout'),
              onTap: () {
                AuthController.instance.logout();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            // todo: Add Google Map widget here
            child: _currentLocation != null
                ? StreamBuilder(
                    stream: ref.child(userID.uid).onValue,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        Map<dynamic, dynamic> map =
                            snapshot.data.snapshot.value ?? {};
                        if (map['UserName'] == null) {
                          map['UserName'] = 'No Name Set';
                        }
                        if (map['Disease'] == null) {
                          map['Disease'] = 'No Disease Set';
                        }
                        userName = map['UserName'];
                        disease = map['Disease'];
                      }
                      return GoogleMap(
                        onMapCreated: (controller) {
                          setState(() {
                            _controller = controller;
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            _currentLocation!.latitude!,
                            _currentLocation!.longitude!,
                          ),
                          zoom: 11.0,
                          tilt: 0,
                          bearing: 0,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('user_location'),
                            position: LatLng(
                              _currentLocation!.latitude!,
                              _currentLocation!.longitude!,
                            ),
                            infoWindow: InfoWindow(
                                title: "Name: $userName",
                                snippet: "Patient Type : $disease"),
                          ),
                        },
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        myLocationButtonEnabled: false,
                        circles: {
                          Circle(
                            circleId: const CircleId('currentCircle'),
                            center: LatLng(_currentLocation!.latitude!,
                                _currentLocation!.longitude!),
                            radius: 1000,
                            fillColor: Colors.blue.shade100.withOpacity(0.5),
                            strokeColor: Colors.blue.shade100.withOpacity(0.1),
                          ),
                        },
                      );
                    })
                : const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
                  ), // Show loading indicator while fetching location
          ),
          // Add zoom buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.add),
                        ),
                        onTap: () {
                          _controller?.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.remove),
                        ),
                        onTap: () {
                          _controller?.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Add the current location button
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 60.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      splashColor: Colors.lightBlue, // inkwell color
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        _controller?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                _currentLocation!.latitude!,
                                _currentLocation!.longitude!,
                              ),
                              zoom: 14.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to send  SMS
  void sendSMS() async {
    dynamic result = await BackgroundSms.isSupportCustomSim;
    if (result) {
      print("Support Custom Sim Slot");
      dynamic result = await BackgroundSms.sendMessage(
          phoneNumber: "0777846270", message: "Message", simSlot: 1);
      if (result == SmsStatus.sent) {
        print("Seeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeent");
      } else {
        print("Faaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaailed");
      }
    } else {
      print("Not Support Custom Sim Slot");
      dynamic result = await BackgroundSms.sendMessage(
          phoneNumber: "0777846270", message: "Message");
      if (result == SmsStatus.sent) {
        print("Seeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeent");
      } else {
        print(
            "Faaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaailed");
      }
    }
  }
}
