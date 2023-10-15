import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:patienttracking/Features/EmergencyContacts/add_contact.dart';
import 'package:patienttracking/User/controllers/session_controller.dart';
import 'package:patienttracking/User/controllers/user_id_session.dart';

class ProfileFormWidget extends StatefulWidget {
  const ProfileFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Users');
  //  contollers for the input fields
  TextEditingController userAddressController = TextEditingController();
  TextEditingController userDiseaseController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();

  // variable for sessionManager
  var sessionManager = SessionManager();

  // variables
  dynamic countryValue;
  dynamic stateValue;
  dynamic cityValue;
  String address = "";

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    String userEmail;
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30 - 10),
      // this function will get current user data form firebase
      child: StreamBuilder(
          stream: ref.child(user!.uid.toString()).onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
              final nameController =
                  TextEditingController(text: map['UserName']);
              final phoneController = TextEditingController(text: map['Phone']);
              userEmail = map["email"].toString();

              return Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User Info",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30 - 10),
                    TextFormField(
                      controller: nameController,
                      // initialValue: map['UserName'],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be valid';
                        }
                        // Return null if the entered username is valid
                        // return null;
                      },

                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        labelText: "Full Name",
                        hintText: "Full Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      // initialValue: map['Phone'],
                      controller: phoneController,

                      validator: (value) {
                        bool _isEmailValid =
                            RegExp(r'^(?:[+0][1-9])?[0-9]{8,15}$')
                                .hasMatch(value!);
                        if (!_isEmailValid) {
                          return 'Invalid phone number';
                        }
                        return null;
                        // return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        labelText: "Phone Number",
                        hintText: "Phone Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      initialValue: map['email'],
                      enableInteractiveSelection: false,
                      focusNode: new AlwaysDisabledFocusNode(),
                      validator: (value) {
                        bool _isEmailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (!_isEmailValid) {
                          return 'Invalid email.';
                        }
                        // return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        labelText: "Email",
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      controller: userDiseaseController,
                      // initialValue: map['email'],
                      // enableInteractiveSelection: false,
                      // focusNode: new AlwaysDisabledFocusNode(),

                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.sick),
                        labelText: "Disease",
                        hintText: "Enter Disease",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      controller: userAddressController,
                      // initialValue: map['email'],
                      // enableInteractiveSelection: false,
                      // focusNode: new AlwaysDisabledFocusNode(),

                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.add_home_rounded),
                        labelText: "Address",
                        hintText: "Home Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),

                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      controller: provinceController,
                      // initialValue: map['email'],
                      // enableInteractiveSelection: false,
                      // focusNode: new AlwaysDisabledFocusNode(),

                      decoration: InputDecoration(
                        prefixIcon: const Icon(CupertinoIcons.placemark),
                        labelText: "Province ",
                        hintText: "Enter province e.g Copperbelt",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),

                    const SizedBox(height: 30 - 20),
                    TextFormField(
                      selectionHeightStyle: BoxHeightStyle.tight,

                      controller: cityController,
                      // initialValue: map['email'],
                      // enableInteractiveSelection: false,
                      // focusNode: new AlwaysDisabledFocusNode(),

                      decoration: InputDecoration(
                        prefixIcon: const Icon(CupertinoIcons.placemark_fill),
                        labelText: "City",
                        hintText: "Enter City e.g Ndola",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    //  Drop Down list for Country and City

                    const SizedBox(height: 30 - 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          // ProfileController.instance?.updateprofile(
                          //   nameController.text!.trim(),
                          //   phoneController.text!.trim(),
                          // );

                          if ((_formkey.currentState)!.validate()) {
                            updateprofile(
                                nameController.text.trim(),
                                phoneController.text.trim(),
                                userAddressController.text.trim(),
                                userDiseaseController.text.trim(),
                                cityController.text.trim(),
                                provinceController.text.trim());

                            Get.snackbar("Save", "Profile Updated",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2));
                          }
                        },
                        child: Text("Update".toUpperCase()),
                      ),
                    ),
                    const SizedBox(height: 30 - 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          Get.to(() => const add_contact(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(seconds: 1),
                              arguments: userEmail);
                        },
                        child: Text("Emergency Contacts".toUpperCase()),
                      ),
                    ),
                  ],
                ),
              );
            }
            // else if (snapshot.hasError) {
            //   return Center(child: Text(snapshot.error.toString()));
            // }
            else {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
              ));
            }
          }),
    );
  }

  // this function to update user profile
  void updateprofile(String name, String phone, String address, String disease,
      String city, String province) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    UserIDSession userIDSession = UserIDSession();
    userIDSession.saveUserID("userID", user.uid);

    ref.child(user.uid).update({
      'UserName': name,
      'Phone': phone,
      'Address': address,
      'Disease': disease,
      'City': city,
      'Province': province,
    });
    print(SessionController().userid);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
