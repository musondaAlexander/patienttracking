import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patienttracking/commonScreens/formFooter.dart';
import 'package:patienttracking/commonScreens/Login/loginForm.dart';

class LogingScreen extends StatelessWidget {
  const LogingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // image: AssetImage("images/logo.png"),
    // This calculates the height of the Screen
    double preferredHeight = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        // bottom: PreferredSize(
        //     preferredSize: Size.fromHeight(preferredHeight),
        //     child: Container(
        //       padding: const EdgeInsets.only(bottom: 10),
        //       child: Column(
        //         children: [
        //           Image(
        //             image: const AssetImage("assets/logos/logoicon.ico"),
        //             height: preferredHeight,
        //           ),
        //           Text(
        //             "Login",
        //             style: TextStyle(
        //                 fontSize: 28,
        //                 fontWeight: FontWeight.w700,
        //                 color: Colors.white),
        //           ),
        //         ],
        //       ),
        //     )),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Get.height * 0.1),
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        image:
                            const AssetImage("assets/logos/logoiconwhite.png"),
                        height: Get.height * 0.1),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Login",
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              LoginForm(),
              FooterWidget(Texts: "Don't have an account ", Title: "Sign Up"),
            ],
          ),
        ),
      ),
    );
  }
}
