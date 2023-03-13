import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_object.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Class Json Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Class Json Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CustomObject> _customObject = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadUserConfiguration();
    });
  }

  loadUserConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final String? peripherals = prefs.getString('peripherals');
    List<dynamic> items = [];

    if (peripherals != null) {
      items =  json.decode(peripherals);
    } else {
      String data = await rootBundle.loadString('lib/peripherals.json');
      items = json.decode(data)["data"];
    }

    for (var element in items) {
      setState(() {
        _customObject.add(CustomObject.fromJson(element));
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("peripherals", json.encode(_customObject));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _deleteChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('peripherals');

      setState(() {
        _customObject = [];
      });

      await loadUserConfiguration();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: <Widget>[
                  for (int index = 0; index < _customObject.length; index += 1)
                    ListTile(
                      key: Key('$index'),
                      leading: Icon(
                          IconData(
                              int.parse(_customObject[index].icon!
                              ),
                              fontFamily: 'MaterialIcons')
                      ),
                      //tileColor: per[index].isOdd ? oddItemColor : evenItemColor,
                      title: Text(_customObject[index].name!),
                      subtitle: Text(_customObject[index].value!),

                    ),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final temp = _customObject[oldIndex];
                    _customObject.removeAt(oldIndex);
                    _customObject.insert(newIndex, temp);
                  });
                },
              )
          ),
          TextButton(
              onPressed: () async {
                await _saveChanges();
              },
              child: const Text("Save Changes")
          ),
          TextButton(
              onPressed: () async {
                await _deleteChanges();
              },
              child: const Text("Delete/Reset Changes")
          )
        ],
      ),
    );
  }
}
