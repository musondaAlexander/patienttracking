import 'package:flutter/material.dart';

class ZambiaLocationSelectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ZambiaLocationSelectorScreen(),
    );
  }
}

class ZambiaLocationSelectorScreen extends StatefulWidget {
  @override
  _ZambiaLocationSelectorScreenState createState() =>
      _ZambiaLocationSelectorScreenState();
}

class _ZambiaLocationSelectorScreenState
    extends State<ZambiaLocationSelectorScreen> {
  String selectedProvince = '';
  String selectedCity = '';

  final Map<String, List<String>> zambiaProvinces = {
    "Central": ["Kabwe", "Kapiri Mposhi", "Serenje"],
    "Copperbelt": ["Ndola", "Kitwe", "Chingola"],
    "Eastern": ["Chipata", "Petauke", "Katete"],
    "Luapula": ["Mansa", "Kawambwa", "Nchelenge"],
    "Lusaka": ["Lusaka", "Chongwe", "Kafue"],
    "Muchinga": ["Chinsali", "Isoka", "Mpika"],
    "North-Western": ["Solwezi", "Mwinilunga", "Kasempa"],
    "Northern": ["Mbala", "Kasama", "Mpulungu"],
    "Southern": ["Livingstone", "Choma", "Monze"],
    "Western": ["Mongu", "Kaoma", "Lukulu"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zambia Location Selector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildDropdown('Province', zambiaProvinces.keys.toList(), (value) {
              setState(() {
                selectedProvince = value;
                selectedCity = '';
              });
            }),
            if (selectedProvince != '') ...[
              _buildDropdown('City', [
                'Select a city',
                ...?zambiaProvinces[selectedProvince]
              ], (value) {
                setState(() {
                  selectedCity = value;
                });
              }),
            ],
            Text(
              'Selected Location: $selectedCity, $selectedProvince, Zambia',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, Function(String) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged as void Function(String?)?,
      value: label == 'City' && selectedCity == null ? null : selectedProvince,
    );
  }
}
