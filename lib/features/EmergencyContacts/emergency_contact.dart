import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late String _contact1 = '';
  late String _contact2 = '';
  late String _contact3 = '';
  late String _contact4 = '';
  late String _contact5 = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _contact1 = prefs.getString('contact1')!;
      _contact2 = prefs.getString('contact2')!;
      _contact3 = prefs.getString('contact3')!;
      _contact4 = prefs.getString('contact4')!;
      _contact5 = prefs.getString('contact5')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const Padding(
                padding: EdgeInsets.only(
              top: 40,
            )),
            const SizedBox(height: 30),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.lightBlueAccent,
              style: ListTileStyle.drawer,
              title: const Text('Contact 1'),
              subtitle: Text(_contact1 ?? ''),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: const Color.fromARGB(255, 208, 221, 227),
              style: ListTileStyle.drawer,
              title: const Text('Contact 2'),
              subtitle: Text(_contact2 ?? ''),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.lightBlueAccent,
              style: ListTileStyle.drawer,
              title: const Text('Contact 3'),
              subtitle: Text(_contact3 ?? ''),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: const Color.fromARGB(255, 208, 221, 227),
              style: ListTileStyle.drawer,
              title: const Text('Contact 4'),
              subtitle: Text(_contact4 ?? ''),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.lightBlueAccent,
              style: ListTileStyle.drawer,
              title: const Text('Contact 5'),
              subtitle: Text(_contact5 ?? ''),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.lightBlueAccent,
              style: ListTileStyle.drawer,
              title: const Text('Contact 6'),
              subtitle: const Text("Send SMS"),
            ),
          ],
        ),
      ),
    );
  }
}
