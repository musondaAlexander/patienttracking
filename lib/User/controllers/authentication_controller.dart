// This controller will be used to Authenticate the User for signin, Login , Logout and other operations.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patienttracking/User/controllers/session_controller.dart';
import 'package:patienttracking/User/screens/DashBoard/user_dashboard.dart';
import 'package:patienttracking/commonScreens/Login/loginScreen.dart';

class AuthController extends GetxController {
  //Need to instantiate the controller
  static AuthController instance = Get.find();
  DatabaseReference ref = FirebaseDatabase.instance.ref('Users');
  late Rx<User?> _user;
  // create an instance of firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  // attach a Stream binder to user
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

// create the initialScreen Method To check if the user is logged in or not
  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LogingScreen());
    } else {
      Get.offAll(() => const UserDashboard());
      // Get.offAll(() => Home(email:user.email!));
    }
  }

  // Signin Method
  void signUp(String username, String email, String password, String Phone,
      String Usertype) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userid = value.user!.uid.toString();

        ref.child(value.user!.uid.toString()).set({
          'email': value.user!.email.toString(),
          // 'password': password,
          'UserName': username,
          'Phone': Phone,
          'UserType': Usertype,
        });
        Get.snackbar("Success", "Sign Up Successfully");
      }).onError((error, stackTrace) {
        if (error.toString().contains("email-already-in-use")) {
          Get.snackbar("Error", "Email Already In Use");
        } else if (error.toString().contains("weak-password")) {
          Get.snackbar("Error", "Password Should Be At Least 6 Characters");
        } else if (error.toString().contains("invalid-email")) {
          Get.snackbar("Error", "Invalid Email");
        } else if (error.toString().contains("network-request-failed")) {
          Get.snackbar("Error", "Check Your Internet Connection");
        } else {
          Get.snackbar("Error", error.toString());
        }
      });
    } catch (error) {
      Get.snackbar("Error", error.toString());
      debugPrint(error.toString());
    }
  }

  // Login Method
  void login(String email, password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userid = value.user!.uid
            .toString(); // Here we are setting the user id in the session controller
        Get.snackbar("Success", "Login Successfully:)");
      }).onError((error, stackTrace) {
        if (error == null) {
          Get.snackbar("Error", "Please Enter Email & Password");
        } else if (error.toString().contains("user-not-found")) {
          Get.snackbar("Error", "User Not Found");
        } else if (error.toString().contains("wrong-password")) {
          Get.snackbar("Error", "Wrong Password");
        } else if (error.toString().contains("invalid-email")) {
          Get.snackbar("Error", "Invalid Email");
        } else if (error.toString().contains("network-request-failed")) {
          Get.snackbar("Error", "Network Error");
        } else if (error.toString().contains("too-many-requests")) {
          Get.snackbar("Error", "Too Many Requests");
        } else if (error.toString().contains("user-disabled")) {
          Get.snackbar("Error", "User Disabled");
        } else if (error.toString().contains("operation-not-allowed")) {
          Get.snackbar("Error", "Operation Not Allowed");
        } else if (error.toString().contains("invalid-credential")) {
          Get.snackbar("Error", "Invalid Credential");
        } else if (error
            .toString()
            .contains("account-exists-with-different-credential")) {
          Get.snackbar("Error", "Account Exists With Different Credential");
        } else if (error.toString().contains("requires-recent-login")) {
          Get.snackbar("Error", "Requires Recent Login");
        } else if (error.toString().contains("email-already-in-use")) {
          Get.snackbar("Error", "Email Already In Use");
        } else if (error.toString().contains("weak-password")) {
          Get.snackbar("Error", "Password Should Be At Least 6 Characters");
        } else if (error.toString().contains("invalid-email")) {
          Get.snackbar("Error", "Invalid Email");
        } else if (error.toString().contains("user-not-found")) {
          Get.snackbar("Error", "User Not Found");
        } else if (error.toString().contains("wrong-password")) {
          Get.snackbar("Error", "Wrong Password");
        } else if (error.toString().contains("invalid-email")) {
          Get.snackbar("Error", "Invalid Email");
        } else if (error.toString().contains("network-request-failed")) {
          Get.snackbar("Error", "Network Error");
        } else if (error.toString().contains("too-many-requests")) {
          Get.snackbar("Error", "Too Many Requests");
        }
      });
    } catch (error) {
      Get.snackbar("Error", error.toString());
    }
  }

//  Logout Method
  void logout() async {
    await auth.signOut();
  }
}
