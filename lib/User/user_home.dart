import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patienttracking/User/screens/DashBoard/user_dashboard.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

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
    );
  }
}
