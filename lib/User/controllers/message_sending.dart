import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:patienttracking/Features/EmergencyContacts/emergency_contact_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class messageController extends GetxController {
  _getPermission() async => await [
        Permission.sms,
      ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  // _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
  //   var result = await BackgroundSms.sendMessage(
  //       phoneNumber: phoneNumber, message: message, simSlot: simSlot);
  //   if (result == SmsStatus.sent) {
  //     print("Sent");
  //   } else {
  //     print("Failed");
  //   }
  // }

  Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;
  static messageController get instance => Get.find();
  final emergencyContactsController = Get.put(EmergencyContactsController());

  String? _currentAddress;
  Position? _currentPosition;

// ===============================================================================

  void _sendSMS(String message, List<String> recipents) async {
    for (var i = 0; i < recipents.length; i++) {
      String _result = await BackgroundSms.sendMessage(
              //add all phone numbers in phone number list
              phoneNumber: recipents[i].toString(),
              message: message)
          .toString();
      // Get.snackbar("SMS", _result);
    }
    Get.snackbar("SMS", "Distress SMS Sent Successfully");

    print(recipents);
  }

// ==============================================================================
// modified send message Function to send the message to multiple contacts

  _sendMessage(String message, List<String> recipents, {int? simSlot}) async {
    for (var i = 0; i < recipents.length; i++) {
      var result = await BackgroundSms.sendMessage(
          phoneNumber: recipents[i].toString(),
          message: message,
          simSlot: simSlot);
      if (result == SmsStatus.sent) {
        Get.snackbar("SMS", "Distress SMS Sent Successfully");
      } else {
        Get.snackbar("SMS", "Distress not sent");
      }
    }
  }

// ================================================================================

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Disabled",
          'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Rejected", 'Location Permissions are denied.');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Rejected",
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
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

  Future<Position> getCurrentPosition() async {
    // final hasSmsPermission = handleSmsPermission();

    final hasPermission = await handleLocationPermission();

    if (!hasPermission) {
      return Position(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0.0,
          headingAccuracy: double.infinity);
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng(_currentPosition!);
      return _currentPosition!;
    }).catchError((e) {
      debugPrint(e);
    });
    return Position(
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> sendLocationViaSMS(String EmergencyType) async {
    await getCurrentPosition().then((_currentAddress) async {
      if (_currentAddress != null) {
        // Get.snackbar("Location", _currentAddress!);
        // final Uri smsLaunchUri = Uri(
        //   scheme: 'sms',
        //   path: '03177674726',
        //   queryParameters: <String, String>{
        //     'body': "HELP me! I am under the water \n http://www.google.com/maps/place/${_currentPosition!.latitude},${_currentPosition!.longitude}"
        //   },
        // );
        // launchUrl(smsLaunchUri);
        // Get.snackbar("Location",
        //     "$_currentPosition.latitude, $_currentPosition.longitude ");
        String message =
            "HELP me! There is a $EmergencyType \n https://www.google.com/maps/place/?=${_currentPosition!.latitude}?=${_currentPosition!.longitude}";
        if (await _isPermissionGranted()) {
          if ((await _supportCustomSim)!) {
            // _sendMessage("0964718792", message, simSlot: 1);
            await emergencyContactsController.loadData().then(
                (emergencyContacts) =>
                    _sendMessage(message, emergencyContacts, simSlot: 1));
          } else {
            await emergencyContactsController.loadData().then(
                (emergencyContacts) =>
                    _sendMessage(message, emergencyContacts));
          }
        } else
          _getPermission();
      }
    });

    // Get.snackbar("Location", "Location not found");
  }
}
