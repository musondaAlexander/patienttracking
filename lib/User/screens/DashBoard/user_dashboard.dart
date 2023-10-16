import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patienttracking/User/screens/DashBoard/grid_dash.dart';
import 'package:patienttracking/User/user_home.dart';
// import 'package:public_emergency_app/Features/User/Controllers/message_sending.dart';
// import 'package:public_emergency_app/Features/User/Screens/DashBoard/grid_dash.dart';

// import '../../Controllers/session_controller.dart';
// import 'login_screen.dart';

// class UserDashboard extends StatefulWidget {
//   const UserDashboard({Key? key}) : super(key: key);

//   @override
//   State<UserDashboard> createState() => _UserDashboardState();
// }

// class _UserDashboardState extends State<UserDashboard> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // messageController().handleSmsPermission();
//   }

//   // final _messageController = Get.put(messageController());
//   // FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlueAccent,
//         title: Center(
//             child: Text(
//           'Welcome',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         )),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(top: Get.height * 0.1),
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: GridDashboard(),
//         ),
//       ),
//     );
//   }
// }

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: GestureDetector(
          onTap: () => {Get.to(() => UserHome())},
          child: const BackButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: Get.height * 0.1),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GridDashboard(),
        ),
      ),
    );
  }
}
