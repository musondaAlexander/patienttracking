import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AcivePoliceOfficers extends StatefulWidget {
  const AcivePoliceOfficers({super.key});

  @override
  State<AcivePoliceOfficers> createState() => _AcivePoliceOfficersState();
}

class _AcivePoliceOfficersState extends State<AcivePoliceOfficers> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ref.child('activeResponders').onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  final tileList = <ListTile>[];
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            AlwaysStoppedAnimation(Colors.lightBlueAccent),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // recursively convert the map
                    Map<String, dynamic> convertMap(Map<dynamic, dynamic> map) {
                      map.forEach((key, value) {
                        if (value is Map) {
                          // it's a map, process it
                          value = convertMap(value);
                        }
                      });
                      // use .from to ensure the keys are Strings
                      return Map<String, dynamic>.from(map);
                    }
                    // return Map.fromEntries(map.entries.map((entry) => MapEntry(entry.key.toString(), entry.value)));
                  }
                  final activeResponders =
                      Map<String, dynamic>.from(snapshot.data!.snapshot.value);
                  activeResponders.forEach((key, value) {
                    print(key);
                    final nextActiveResponder =
                        Map<String, dynamic>.from(value);
                    final ActiveResponderOder = ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      tileColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(
                        nextActiveResponder['responderType'],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Latitude: ${nextActiveResponder['lat'].toString()} \nLongitude: ${nextActiveResponder['long'].toString()}",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(255, 255, 255, 1)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.directions),
                        onPressed: () {
                          // Get.to(() => MyLocationMap(
                          //     nextActiveResponder['responderID']));
                        },
                      ),
                    );
                    tileList.add(ActiveResponderOder);
                  });
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 10),
                      child: ListView(
                        children: tileList,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
