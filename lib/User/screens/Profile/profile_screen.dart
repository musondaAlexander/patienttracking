import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patienttracking/User/screens/Profile/profile_screen_form.dart';
import 'package:patienttracking/User/user_home.dart';
import 'package:patienttracking/commonScreens/Login/loginScreen.dart';
import '../../controllers/session_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(
            side: BorderSide(color: Colors.white24, width: 4)),
        onPressed: () {
          FirebaseAuth auth = FirebaseAuth.instance;

          auth.signOut().then((value) {
            SessionController().userid = '';
            Get.offAll(() => const LogingScreen());
          });
        },
        child: const Icon(Icons.person),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: GestureDetector(
          onTap: () => {Get.to(() => UserHome())},
          child: const BackButton(
            color: Colors.white,
          ),
        ),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: const Column(
            children: [
              ProfileFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
