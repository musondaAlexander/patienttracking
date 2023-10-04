import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patienttracking/User/screens/DashBoard/user_dashboard.dart';
import 'package:location/location.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  GoogleMapController? _controller;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _initLocation();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Center(
            child: Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
              leading: Icon(
                Icons.account_circle,
                color: Colors.grey,
              ),
              title: Text('Profile'),
              onTap: () {
                // Handle profile item click
              },
            ),
            GestureDetector(
              onTap: () {
                // Handle dashboard item click
                Get.to(() => UserDashboard());
              },
              child: ListTile(
                leading: Icon(
                  Icons.dashboard,
                  color: Colors.grey,
                ),
                title: Text('Dashboard'),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.contact_emergency,
                color: Colors.grey,
              ),
              title: Text('Emergency contacts'),
              onTap: () {
                // Handle profile item click
              },
            ),

            // Add more items as needed
            Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.grey,
              ),
              title: Text('Logout'),
              onTap: () {
                // Handle logout item click
              },
            ),
          ],
        ),
      ),
      body: Center(
        // todo: Add Google Map widget here
        child: _currentLocation != null
            ? GoogleMap(
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
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('user_location'),
                    position: LatLng(
                      _currentLocation!.latitude!,
                      _currentLocation!.longitude!,
                    ),
                    infoWindow: InfoWindow(
                        title: 'Name: Alexander Musonda',
                        snippet: 'Patient Type : Covid-19'),
                  ),
                },
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
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
              )
            : const CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
              ), // Show loading indicator while fetching location
      ),
    );
  }
}
