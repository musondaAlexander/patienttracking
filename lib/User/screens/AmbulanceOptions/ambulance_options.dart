import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:patienttracking/User/controllers/message_sending.dart';
import 'package:patienttracking/User/screens/AmbulanceOptions/active_ambulances.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class AmbulanceOptions extends StatefulWidget {
  const AmbulanceOptions({super.key});

  @override
  State<AmbulanceOptions> createState() => _AmbulanceoptionsState();
}

class _AmbulanceoptionsState extends State<AmbulanceOptions> {
  final smsController = Get.put(messageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Police Options',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: Colors.blue.shade300,
                leading: const Icon(Icons.map),
                title: const Text('Ambulance Map Display'),
                subtitle:
                    const Text('Find the nearest Ambulance station on the map'),
                // trailing: Icon(Icons.police),
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  var lat = position.latitude;
                  var long = position.longitude;
                  String url = '';
                  String urlAppleMaps = '';
                  if (Platform.isAndroid) {
                    url =
                        "https://www.google.com/maps/search/ambulance/@$lat,$long,12.5z";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  } else {
                    urlAppleMaps = 'https://maps.apple.com/?q=$lat,$long';
                    url =
                        'comgooglemaps://?saddr=&daddr=$lat,$long&directionsmode=driving';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
                      await launchUrl(Uri.parse(urlAppleMaps));
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                  // Add code here to display the nearest police station on the map
                },
              ),
            ),
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: const Color.fromARGB(255, 103, 172, 232),
                leading: const Icon(Icons.local_police),
                title: const Text('See Active Ambulances'),
                subtitle: const Text(
                    'Find the nearest Ambulance stattion on the map'),
                onTap: () {
                  Get.to(const ActiveAmbulances());
                },
              ),
            ),
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: Colors.blue.shade600,
                leading: const Icon(Icons.call),
                title: const Text('Call'),
                subtitle: const Text('Directly call the Ambulance helpline'),
                onTap: () async {
                  if (await Permission.phone.request().isGranted) {
                    debugPrint("In making phone call");
                    var url = Uri.parse("tel:991");
                    await launchUrl(url);
                    debugPrint("Location Permission is granted");
                  } else {
                    debugPrint("Location Permission is denied.");
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: const Color(0xfff85757),
                leading: const Icon(Icons.message),
                title: const Text('Send Distress Message'),
                subtitle:
                    const Text('Send a distress message to emergency contacts'),
                onTap: () {
                  smsController.sendLocationViaSMS(
                      "Ambulance Emergency\nSend an Ambulance at");
                  // Add code here to send a distress message to emergency contacts
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
