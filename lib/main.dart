import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'person.dart';

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
  List<Person> _person = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadUserConfiguration();
    });
  }

  loadUserConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final String? person = prefs.getString('persons');
    List<dynamic> items = [];

    if (person != null) {
      items =  json.decode(person!);
    } else {
      String data = await rootBundle.loadString('lib/persons.json');
      items = json.decode(data)["data"];
    }

    items.forEach((element) {
      setState(() {
        _person.add(Person.fromJson(element));
      });
    });
  }

  Future<void> _saveChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("persons", json.encode(_person));
    } catch (e) {
      print(e.toString());
    }

  }

  Future<void> _deleteChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('persons');

      setState(() {
        _person = [];
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
                  for (int index = 0; index < _person.length; index += 1)
                    ListTile(
                      key: Key('$index'),
                      //tileColor: per[index].isOdd ? oddItemColor : evenItemColor,
                      title: Text('Item ${_person[index].name}'),
                      subtitle: Text('Sub ${_person[index].value}'),
                    ),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final ppp = _person[oldIndex];
                    final a = _person[oldIndex].name;
                    final b = _person[oldIndex].value;
                    final item = _person.removeAt(oldIndex);
                    _person.insert(newIndex, ppp);
                  });
                },
              )
          ),
          TextButton(
              onPressed: () async {
                await _saveChanges();
              },
              child: Text("Save Changes")
          ),
          TextButton(
              onPressed: () async {
                await _deleteChanges();
              },
              child: Text("Delete/Reset Changes")
          )
        ],
      ),
    );
  }
}
