import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:patienttracking/commonScreens/Login/loginScreen.dart';
import 'package:patienttracking/commonScreens/nav_bar.dart';
import 'package:patienttracking/Features/Ambulance/ambulance_dashboard.dart';
import 'package:patienttracking/Features/FireFighters/firefighter_dashboard.dart';
import 'package:patienttracking/Features/Police/police_dashboard.dart';
import 'package:patienttracking/models/appuser.dart';

// This Widget will be used to verify Email of the User.
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // Variables to use in the class
  bool isEmailVerified = false;
  Timer? timer;
  String userType = "";
  bool canResendEmail = true;
  Widget Screen = const NavBar();

// Future fucntion to get the user from firebase database
  Future<String> getUserType() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var ref =
        FirebaseDatabase.instance.ref().child('Users').child(firebaseUser!.uid);
    final snapshot = await ref.get(); // you should use await on async methods
    if (snapshot!.value != null) {
      var userCurrentInfo = AppUser.fromSnapshot(snapshot);
      setState(() {
        userType = userCurrentInfo.userType;
        debugPrint("User Type: $userType");
      });
      return userCurrentInfo.userType;
    } else {
      return "Error";
    }
  }

// Set Screen Arcording to the user
  screenAccordingToUser() async {
    await getUserType().then((value) {
      if (userType == "Police") {
        setState(() {
          Screen = const PoliceDashboard();
        });
        return const PoliceDashboard();
      } else if (userType == "FireFighter") {
        setState(() {
          Screen = const FirefighterDashboard();
        });
        return const FirefighterDashboard();
      } else if (userType == "Ambulance") {
        setState(() {
          Screen = const AmbulanceDashboard();
        });
        return const AmbulanceDashboard();
      } else {
        setState(() {
          Screen = const NavBar();
        });
        return const NavBar();
      }
    });
    return const NavBar();
  }

// init method to check if user email is verified and set a timer
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    screenAccordingToUser();
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

// To dispose  the widgets when its cancled and prevent memory leaks
  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

//  To check if mailhas been sent and cancel the Timer
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

// To send VerificationEmail
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? Screen
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            centerTitle: true,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(110.0),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Verify Email",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A Verification email has been sent to your email.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlueAccent,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  icon: const Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: const Text(
                    'Resend Email',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(20),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut().then((value) {
                      // SessionController().userid = '';
                      Get.offAll(() => const LogingScreen());
                    });
                  },
                ),
              ],
            ),
          ),
        );
}
